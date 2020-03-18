//
//  CharacteristicExtensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/18/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import CoreBluetooth

extension CBCharacteristic {
  func griffyDisplayValue() -> String {
    return value?.griffyDisplayValue(characteristicId: uuid.uuidString) ?? "🤦‍♀️"
  }
  
  var griffyCharacteristic: GFCharacteristic? {
    return GFCharacteristic.find(GFCharacteristic.self, byId: uuid.uuidString)
  }
  
  struct CharacteristicInputError {
    var success: Bool
    var error: String
  }
  
  var gfBleObject: BLEConstants.GFBLEObject? {
    return BLEConstants.gfBleObjects.first(where: { $0.uuid == uuid.uuidString })
  }
  
  func griffyName() -> String {
    return gfBleObject?.displayName ?? "Missing Name!"
  }
  
  func isValidInput(input: String) -> CharacteristicInputError {
    let myId = uuid.uuidString
    if myId == BLEConstants.CharacteristicIds.testId {
      let intValue = Int(input) ?? -1
      return CharacteristicInputError(success: intValue == 0 || intValue == 1, error: "Must be 0 or 1")
    } else if myId == BLEConstants.CharacteristicIds.brightnessId {
      let split = input.split(separator: ",")
      if split.count != 2 {
        return CharacteristicInputError(success: false, error: "Must have 2 values, each >= 0, <= 31")
      }
      var allGood = true
      for digit in split {
        let doubleValue = Double(digit) ?? -1.0
        if !(doubleValue <= 31 && doubleValue >= 0) {
          allGood = false
        }
      }
      return CharacteristicInputError(success: allGood, error: "Must be >= 0 and <= 31")
    } else if myId == BLEConstants.CharacteristicIds.isReversedId {
      let intValue = Int(input) ?? -1
      return CharacteristicInputError(success: intValue == 0 || intValue == 1, error: "Must be 0 or 1")
    } else if myId == BLEConstants.CharacteristicIds.speedThresholdId {
      let split = input.split(separator: ",")
      if split.count != 2 {
        return CharacteristicInputError(success: false, error: "Must have 2 values, each >= 0.00, <= 2.55")
      }
      var allGood = true
      for digit in split {
        let doubleValue = Double(digit) ?? -1.0
        if doubleValue > 2.55 || doubleValue < 0 {
          allGood = false
        }
      }
      
      return CharacteristicInputError(success: allGood, error: "Each number must be >= 0, < 10, and < 3 digits")
    } else if myId == BLEConstants.CharacteristicIds.connectTimeoutId {
      let intValue = Int(input) ?? -1
      return CharacteristicInputError(success: intValue >= 0, error: "Must be >= 0")
    } else if myId == BLEConstants.CharacteristicIds.imu1Id || myId == BLEConstants.CharacteristicIds.imu2Id {
      let split = input.split(separator: ",")
      if split.count != 6 {
        return CharacteristicInputError(success: false, error: "Must have 6 values!")
      }
      
      return CharacteristicInputError(success: true, error: "Must have 6 values!")
    } else {
      //TODO: Add 'em all
//      return CharacteristicInputError(success: false, error: "Can't update this value (yet)...")
      return CharacteristicInputError(success: true, error: "Not validating, but go for it")
    }
  }
}
