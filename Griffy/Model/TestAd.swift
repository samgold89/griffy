//
//  TestAd.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift

class TestAd: BaseObject {
  @discardableResult
  override class func parse<T: Object>(_ type: T.Type, dictionary: [String: Any?], update: Bool = true) -> T? {
    let newT = super.parse(type, dictionary: dictionary, update: update)
    guard let ta = newT as? TestAd else { return newT }
    if ta.shouldDownloadRadials {
      ta.downloadRadials()
    }
    return newT
  }
  
  // 700 image slots
  @objc dynamic var type: String! // test vs. ¿live?
  @objc dynamic var active: Bool = true
  @objc dynamic var baseName: String!
  @objc dynamic var baseKey: String!
  @objc private dynamic var thumbnailUrl: String!
  @objc private dynamic var thumbnailGifUrl: String?
  @objc dynamic var frameDuration: Double = 0.5
  
  let hrRadUrls = List<HrRadFrame>()
  let stdRadUrls = List<StdRadFrame>()
  
  var thumbUrl: String! {
    if let u = thumbnailGifUrl {
      return u
    } else {
      return thumbnailUrl
    }
  }
  
  var baseKeyForFileStorage: String {
    return baseKey.replacingOccurrences(of: "/", with: "-")
  }
  
  var stdStartIndexOnWheel: Int? {
    guard let pump = Pump.activePump, let memory = pump.adMemoryMap else { return nil }
    return memory.existingStartIndex(forAd: self)?.stdResStartIndex
  }
  
  var hrStartIndexOnWheel: Int? {
    guard let pump = Pump.activePump, let memory = pump.adMemoryMap else { return nil }
    return memory.existingStartIndex(forAd: self)?.hrResStartIndex
  }
    
  var stdIsOnWheel: Bool {
    return stdStartIndexOnWheel != nil
  }
  
  var hrIsOnWheel: Bool {
    return hrStartIndexOnWheel != nil
  }
  
  var isAnimation: Bool {
    guard let stdRadFilePaths = stdRadFilePaths else { return false }
    return stdRadFilePaths.count > 1
  }
  
  var frameCount: Int {
    guard let stdRadFilePaths = stdRadFilePaths else { return 1 }
    return stdRadFilePaths.count
  }

  enum AdSendType {
    case std
    case hr
    case both
  }
  
  struct AdSendError {
    var error: String
  }
  
  func sendToWheel(adSendType: AdSendType) -> AdSendError? {
    guard let pump = Pump.activePump, let memory = pump.adMemoryMap else {
      return AdSendError(error: "Failed to find an active wheel and a memory map. Wheel: \(Pump.activePump)")
    }
//    assert(!stdIsOnWheel && (!hrIsOnWheel || tryHighRes), "Shouldn't be sending to wheel if the ad already exists on the wheel! Set active: \(memory.existingStartIndex(forAd: self)?.stdResStartIndex ?? -1)")
    
    let info = memory.assignStartIndex(forAd: self, sendType: adSendType)
    BluetoothManager.shared.sendAdToDevice(ad: self, withWheelInfo: info)
    return nil
  }
  
  func setActiveOnWheel(useHighRes: Bool) {
    BluetoothManager.shared.setAdActive(ad: self, useHighRes: useHighRes)
  }
  
  var hrRadFilePaths: [String]? {
    let ad = AdFileManager(ad: self)
    do {
      let paths = try FileManager.default.contentsOfDirectory(atPath: ad.hrRadFolderUrl.relativePath).map({ ad.hrRadFolderUrl.appendingPathComponent($0).relativePath })
      return paths.count == 0 ? nil : paths
    } catch {
      return nil
    }
  }
  
  var stdRadFilePaths: [String]? {
    let ad = AdFileManager(ad: self)
    do {
      let paths = try FileManager.default.contentsOfDirectory(atPath: ad.stdRadFolderUrl.relativePath).map({ ad.stdRadFolderUrl.appendingPathComponent($0).relativePath })
      return paths.count == 0 ? nil : paths
    } catch {
      return nil
    }
  }
  
  var shouldDownloadRadials: Bool {
    let ad = AdFileManager(ad: self)
    return ad.shouldDownloadRadials
  }
  
  func downloadRadials() {
    let ad = AdFileManager(ad: self)
    ad.downloadAllRadials()
  }
}
