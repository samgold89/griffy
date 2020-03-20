//
//  WheelMemory.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift

class AdMemoryMap: Object {
  
  static let defaultMemorySize = 352 // might drop to half with hi-res exansion
  
  @objc dynamic var peripheralName: String!
  /// A list of encoded PumpMemoryItems
  private let assignedMemory = List<Data>()
  
  @objc private dynamic var totalMemorySlots: Int = AdMemoryMap.defaultMemorySize
  
  required init(memorySize: Int) {
    super.init()
    totalMemorySlots = memorySize
  }
  
  required init() {
//    assertionFailure("Shouldn't initialize from here. User memory size")
    super.init()
  }
  
  public static func create(withPeripheralName name: String, memorySize: Int) {
    let realm = try! Realm()
    try! realm.write {
      let adMem = realm.create(AdMemoryMap.self)
      adMem.peripheralName = name
      adMem.totalMemorySlots = memorySize
    }
  }
  
  public static var activeMemoryMap: AdMemoryMap? {
    guard let pName = BluetoothManager.shared.griffyPeripheral?.name else { return nil }
    
    let realm = try! Realm()
    let obj = realm.objects(AdMemoryMap.self).first { (map) -> Bool in
      map.peripheralName == pName
    }
    return obj
  }
  
  /// We'll track memory on the wheel by keeping an array of PumpMemoryItem. This will allow
  /// us to traverse to find a slot of length N
  struct PumpMemoryItem: Codable {
    var wheelStartIndex: Int // the starting index for this item
    var length: Int // the number of slots this item takes up
    var inputDate: Date // the date this was put onto the wheel
    var isHighRes: Bool
    var adId: Int
    
    var data: Data? {
      let data = try? PropertyListEncoder().encode(self)
      return data
    }
  }
  
  private var memoryItems: [PumpMemoryItem]? {
    return assignedMemory.compactMap({$0.wheelMemoryItem})
                               .sorted(by: {$0.wheelStartIndex < $1.wheelStartIndex})
  }
  private var availableSlotCount: Int {
    guard let memoryItems = memoryItems else { return 0 }
    return totalMemorySlots - memoryItems.map({$0.length}).reduce(0, +)
  }
  
//  MARK: Get ads from wheel
  struct PumpMemoryPlacement {
    var stdResStartIndex: Int?
    var hrResStartIndex: Int?
  }
  func existingStartIndex(forAd ad: TestAd) -> PumpMemoryPlacement? {
    guard let memoryItems = memoryItems else { return nil }
    var stdIdx, hrIdx: Int?
    let matchedAds = memoryItems.filter({ $0.adId == ad.id })
    
    assert(matchedAds.count < 3, "Shouldn't have more than 2 items in for a given ad. Low-res & high-res")
    
    if let stdStart = matchedAds.filter({ $0.isHighRes == false }).first {
      stdIdx = stdStart.wheelStartIndex
    }
    if let hrStart = matchedAds.filter({ $0.isHighRes == true }).first {
      hrIdx = hrStart.wheelStartIndex
    }
    return PumpMemoryPlacement(stdResStartIndex: stdIdx!, hrResStartIndex: hrIdx)
  }
  
  /// Analyzes the wheels current memory utilization and returns the indices to use to put a new Ad on the wheel
  /// First check existingStartIndex before assigning new placement. Function analyzes current memory on wheel
  /// and returns either free slots or slots that can be clobbered.
  /// If we're not trying high res, PumpMemoryPlacement will return nil for hiResIndex
  /// - Parameter ad: The Ad we need to make space for
  func assignStartIndex(forAd ad: TestAd, sendType: TestAd.AdSendType) -> PumpMemoryPlacement {
    assert(existingStartIndex(forAd: ad) == nil)
    // needs sequential memory for std, needs sequential memory for hr, those don't have to be next to each other
    let stdSlotsNeeded = ad.stdRadFilePaths?.count ?? 0
    let hrSlotsNeeded = ad.hrRadFilePaths?.count ?? 0
    var neededSpace = 0
    switch sendType {
    case .std:
      neededSpace += stdSlotsNeeded
    case .hr:
      neededSpace += hrSlotsNeeded
    case .both:
      neededSpace += (stdSlotsNeeded + hrSlotsNeeded)
    }
    
    guard neededSpace > 0 else {
      assertionFailure("Should have files before assigning a start index.")
      return PumpMemoryPlacement(stdResStartIndex: -1, hrResStartIndex: -1)
    }
    
    // This assumes sequential memory. Once we're full, that's it.
    if availableSlotCount > neededSpace {
      var stdStartIndex: Int?
      var hrStartIndex: Int?
      
      switch sendType {
      case .std:
        stdStartIndex = availableSlotCount
        
        // Add & create the entry for standard resolution images
        let memoryItem = PumpMemoryItem(wheelStartIndex: stdStartIndex!, length: stdSlotsNeeded, inputDate: Date(), isHighRes: false, adId: ad.id)
        addMemoryItem(item: memoryItem)
      case .hr:
        hrStartIndex = availableSlotCount
        
        // If relevant, add & create the entry to high resolution images
        if let hrStartIndex = hrStartIndex, hrSlotsNeeded > 0 {
          let memoryItem = PumpMemoryItem(wheelStartIndex: hrStartIndex, length: hrSlotsNeeded, inputDate: Date(), isHighRes: true, adId: ad.id)
          addMemoryItem(item: memoryItem)
        }
      case .both:
        stdStartIndex = availableSlotCount
        hrStartIndex = hrSlotsNeeded > 0 ? availableSlotCount + stdSlotsNeeded : nil
        
        // Add & create the entry for standard resolution images
        let memoryItem = PumpMemoryItem(wheelStartIndex: stdStartIndex!, length: stdSlotsNeeded, inputDate: Date(), isHighRes: false, adId: ad.id)
        addMemoryItem(item: memoryItem)
        
        // If relevant, add & create the entry to high resolution images
        if let hrStartIndex = hrStartIndex, hrSlotsNeeded > 0 {
          let memoryItem = PumpMemoryItem(wheelStartIndex: hrStartIndex, length: hrSlotsNeeded, inputDate: Date(), isHighRes: true, adId: ad.id)
          addMemoryItem(item: memoryItem)
        }
      }
      
      // Return something easy to handle
      let memorySlots = PumpMemoryPlacement(stdResStartIndex: stdStartIndex, hrResStartIndex: hrStartIndex)
      return memorySlots
    } else {
      assertionFailure("We ain't ready for this yet...")
      // We'll need to remove something from memory
      // Remove it from the assiged array
      return PumpMemoryPlacement(stdResStartIndex: -1, hrResStartIndex: -1)
    }
  }
  
  fileprivate func addMemoryItem(item: PumpMemoryItem) {
    let realm = try! Realm()
    try! realm.write {
      guard let itemData = item.data else { return }
      assignedMemory.append(itemData)
    }
  }
  
  fileprivate func removeMemoryItem(item: PumpMemoryItem) {
    let realm = try! Realm()
    try! realm.write {
      guard let itemData = item.data else { return }
      guard let idx = assignedMemory.index(of: itemData) else { return }
      assignedMemory.remove(at: idx)
    }
  }
}
