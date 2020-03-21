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
  
  var griffyDisplayValue: String? {
    return value?.griffyDisplayValue(characteristicId: uuid)
  }
  
  var bleObject: BLEConstants.GFBLEObject! {
    return BLEConstants.gfBleObjects.first(where: { $0.uuid == uuid })
  }
  
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
  
  public static var imageSelect: GFCharacteristic? {
    get {
      GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.imageSelectId)
    }
  }
  
  public static var imageLoad: GFCharacteristic? {
    get {
      GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.imageLoadId)
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
  
  public static var connectTimeout: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.connectTimeoutId)
    }
  }
  
  public static var activeLog: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.activeLog)
    }
  }
  
  public static var logClockTickReset: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.logClockTickReset)
    }
  }
  
  public static var loggingPeriod: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.loggingPeriod)
    }
  }
  
  public static var logMemCount0: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.logMemCount0)
    }
  }
  
  public static var logMemCount1: GFCharacteristic? {
    get {
      return GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.logMemCount1)
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
