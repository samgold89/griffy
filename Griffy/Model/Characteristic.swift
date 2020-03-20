//
//  ModelCharacteristic.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/3/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift

class GFCharacteristic: BLEBaseObject {
  @objc dynamic var name = ""
  @objc dynamic var uuid = ""
  @objc dynamic var value: Data? = nil
  
  public static var isHighRes: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.isHighResolutionId)
    }
  }
  
  public static var animation: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.animationId)
    }
  }
  
  public static var frameCount: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.frameCountId)
    }
  }
  
  public static var frameDuration: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.frameDurationId)
    }
  }
  
  public static var status: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.statusId)
    }
  }
  
  public static var serialNumber: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.serialNumberId)
    }
  }
  
  public static var displayFormat: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.serialNumberId)
    }
  }
  
  public static var hardwareVersion: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.hardwareVersionId)
    }
  }
  
  var bleObject: BLEConstants.GFBLEObject? {
    return BLEConstants.gfBleObjects.first(where: { $0.uuid == uuid })
  }
  
  var isReadable: Bool {
    bleObject?.isReadable ?? false
  }
  
  var isUInt8: Bool {
    guard let type = bleObject?.parseDataType else { return true }
    return type == .uint8 || type == .uint8array
  }
  
  var isUInt16: Bool {
    guard let type = bleObject?.parseDataType else { return true }
    return type == .uint16 || type == .uint16array
  }
  
  var isUInt32: Bool {
    guard let type = bleObject?.parseDataType else { return true }
    return type == .uint32
  }
}
