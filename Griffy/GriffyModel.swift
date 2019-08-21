//
//  GriffyModel.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/25/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift
import CoreBluetooth

class GFObject: Object {
  @objc dynamic var updatedAt: Date? = nil
  @objc dynamic var deletedAt: Date? = nil
  @objc dynamic var id = ""
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  public static func find<T: Object>(_ type: T.Type, byId id: String) -> T? {
    let realm = try! Realm()
    return realm.objects(T.self).filter(NSPredicate(format: "id = %@",id)).first
  }

  public static func findAll<T: Object>(_ type: T.Type) -> [T] {
    var allThings = [T]()
    let realm = try! Realm()
    try! realm.write {
      allThings = Array(realm.objects(T.self))
    }
    return allThings
  }

  public static func parse<T: Object>(_ type: T.Type, characteristic: CBCharacteristic) -> T? {
    let realm = try! Realm()
    
    var modified: T?
    try! realm.write {
      let dict = ["id": characteristic.uuid.uuidString, "uuid": characteristic.uuid.uuidString, "updatedAt": Date(), "name": characteristic.griffyName(), "value": characteristic.value ?? Data()] as [String : Any]
      modified = realm.create(T.self, value: dict, update: true)
      if let m = modified as? GFObject {
        if m.deletedAt != nil {
          realm.delete(modified!)
          modified = nil
        }
      }
    }
    
    return modified
  }
}

class GFCharacteristic: GFObject {
  @objc dynamic var name = ""
  @objc dynamic var uuid = ""
  @objc dynamic var value: Data? = nil
  
  public static var isHighRes: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.isHighResolutionId)
    }
  }
  
  public static var animation: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.animationId)
    }
  }
  
  public static var frameCount: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.frameCountId)
    }
  }
  
  public static var frameDuration: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.frameDurationId)
    }
  }
  
  public static var status: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.statusId)
    }
  }
  
//  public static var watts: String {
//    get {
//      let myWatts = 0
//      guard let combinedCurrent = GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.instantCurrentId)?.griffyDisplayValue(), let combinedVoltagee =  GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.voltageId)?.griffyDisplayValue() else {
//        return "noVal"
//      }
//
  //      let currents = combinedCurrent.split(separator: ",").map({Float($0)})
//      let voltages = combinedVoltagee.split(separator: ",").map({Float($0)})
////      guard let currents =
//      return "(\(myWatts))"
//    }
//  }
//
//  func griffyDisplayValue() -> String? {
//    return value?.griffyDisplayValue(characteristicId: id)
//  }
  
  var isReadable: Bool {
    return ReadableCharacterIds.contains(uuid)
  }
  
  var isUInt8: Bool {
    return uiint8ids.contains(id) || uiint8ArrayIds.contains(id)
  }
  
  var isUInt16: Bool {
    return uiint16Ids.contains(id) || uiint16ArrayIds.contains(id)
  }
  
  var isUInt32: Bool {
    return uiint32Ids.contains(id)
  }
}

// Use them like regular Swift objects
//let myDog = GFCharacteristic()
//myDog.value = "Rex"
//myDog.uuid = "1234"

// Get the default Realm
//let realm = try! Realm()

// Query Realm for all dogs less than 2 years old
//let puppies = realm.objects(Dog.self).filter("age < 2")
//puppies.count // => 0 because no dogs have been added to the Realm yet

// Persist your data easily
//try! realm.write {
//  realm.add(myDog)
//}

extension Results {
  func GFObseveDataChanges(for someTableView: UITableView, animateChanges: Bool) -> NotificationToken {
    weak var tableView = someTableView
    let token = self.observe {(changes: RealmCollectionChange) in
      guard let tableView = tableView else { return }
      switch changes {
      case .initial:
        // Results are now populated and can be accessed without blocking the UI
        tableView.reloadData()
        break
      case .update( _, let deletions, let insertions, let modifications):
        //Query results have changed, so apply them to the UITableView
        if animateChanges {
          tableView.beginUpdates()
          tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                               with: .automatic)
          tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                               with: .automatic)
          tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                               with: .automatic)
          tableView.endUpdates()
        } else {
          tableView.reloadData()
        }
        break
      case .error(let error):
        // An error occurred while opening the Realm file on the background worker thread
        fatalError("\(error)")
        break
      }
    }
    return token
  }
  
  func GFObseveDataChanges(for someTableView: UITableView) -> NotificationToken {
    //**WARNING** currently 3/21/17, Realm has a known bug where ALL results are
    //returned even if nothing has changes. Annoying, but calling beginUpdates()
    //causes too much flickering. For now, reloadData() will have to do
    return GFObseveDataChanges(for: someTableView, animateChanges: false)
  }
  
  func GFObseveDataChanges(for someCollectionView: UICollectionView) -> NotificationToken {
    //**WARNING** currently 3/21/17, Realm has a known bug where ALL results are
    //returned even if nothing has changes. Annoying, but calling beginUpdates()
    //causes too much flickering. For now, reloadData() will have to do
    weak var collectionView = someCollectionView
    let token = self.observe {(changes: RealmCollectionChange) in
      guard let collectionView = collectionView else { return }
      switch changes {
      case .initial:
        // Results are now populated and can be accessed without blocking the UI
        collectionView.reloadData()
        break
      case .update( _, let deletions, let insertions, let modifications):
        collectionView.reloadData()
        break
      case .error(let error):
        // An error occurred while opening the Realm file on the background worker thread
        fatalError("\(error)")
        break
      }
    }
    return token
  }
}
