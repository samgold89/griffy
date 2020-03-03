//
//  ModelCharacteristic.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/3/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift

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
