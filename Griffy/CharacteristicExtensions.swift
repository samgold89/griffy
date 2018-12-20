//
//  CharacteristicExtensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/18/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import CoreBluetooth

//UIInt16
//alu1
//alu2
//wheel Speed
//connect Timeout

//uint16[2]
//temperature
//instant Current
//average Current
//voltage
//seconds Remaining
//percentage Charge
//mah Remaining

//UIInt32
//hardware Version
//firmware Version

//UIInt8
//led Pitch
//imu1
//imu2
//status
//image Select
//image Erase
//test

//UIInt8[]
//image Load
//speed Threshold
//brightness
//serial Number

extension Data {
  func griffyValue(characteristicId: String) -> [String]? {//Array<Any>? {
    let uiint16Ids = [CharacteristicAlu1Id,CharacteristicAlu2Id,CharacteristicWheelspeedId,CharacteristicConnecttimeoutId]
    let uiint16ArrayIds = [CharacteristicTemperatureId, CharacteristicInstantcurrentId, CharacteristicAveragecurrentId, CharacteristicVoltageId, CharacteristicSecondsremainingId, CharacteristicPercentagechargeId, CharacteristicMahremainingId]
    let uiint32Ids = [CharacteristicHardwareversionId, CharacteristicFirmwareversionId]
    let uiint8ids = [CharacteristicLedpitchId, CharacteristicImu1Id, CharacteristicImu2Id, CharacteristicStatusId, CharacteristicImageselectId, CharacteristicImageeraseId, CharacteristicTestId]
    let uiint8ArrayIds = [CharacteristicImageloadId, CharacteristicSpeedthresholdId, CharacteristicBrightnessId]
    let serialId = [CharacteristicSerialnumberId]
    
    if characteristicId == CharacteristicIds.imu1Id || characteristicId == CharacteristicIds.imu2Id {
      var array = [String]()
      var idx = 0
      while idx < self.count-1 {
        let chunk1 = Data(bytes: [self[idx],self[idx+1]], count: 2)
        array.append("\(Int(chunk1.uint16))")
        idx += 2
      }
      return array
    } else if uiint16Ids.contains(characteristicId) {
      return ["\(Int(self.uint16))"]
    } else if uiint32Ids.contains(characteristicId) {
      return ["\(Int(self.uint32))"]
    } else if uiint8ids.contains(characteristicId) {
      return ["\(Int(self.uint8))"]
    } else if uiint8ArrayIds.contains(characteristicId) {
      var array = [String]()
      self.forEach({ (int8byte) in
        array.append("\(Int(int8byte))")
      })
      return array
    } else if uiint16ArrayIds.contains(characteristicId) {
      var array = [String]()
      var idx = 0
      while idx < self.count-1 {
        let chunk1 = Data(bytes: [self[idx],self[idx+1]], count: 2)
        array.append("\(Int(chunk1.uint16))")
        idx += 2
      }
      return array
    } else if serialId.contains(characteristicId) {
      var array = [String]()
      self.forEach({ (int8byte) in
        let string = "\(Character(UnicodeScalar(UInt32("\(Int(int8byte).toDecimal())", radix: 16)!)!))"
        array.append(string)
      })
      
      let joinedArray = [(array.compactMap { $0 == nil ? nil : String($0!) }).joined()]
      return joinedArray
    } else {
      assertionFailure("Not handling the parsing of some kind of thing.")
      return [""]
    }
  }
}
extension CBCharacteristic {
  func griffyValue() -> [String]? {
    return value?.griffyValue(characteristicId: uuid.uuidString) ?? [""]
  }
  
  func griffyName() -> String {
    return characteristicNameById[uuid.uuidString] ?? "Missing Name!"
  }
  
  func griffyCharacteristic() -> GFCharacteristic? {
    return GFCharacteristic.find(GFCharacteristic.self, byId: uuid.uuidString)
  }
  
  struct CharacteristicInputError {
    var success: Bool
    var error: String
  }
  
  func isValidInput(input: String) -> CharacteristicInputError {
    let myId = uuid.uuidString
    if myId == CharacteristicIds.testId {
      let intValue = Int(input) ?? -1
      return CharacteristicInputError(success: intValue == 0 || intValue == 1, error: "Must be 0 or 1")
    } else if myId == CharacteristicIds.brightnessId {
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
    } else if myId == CharacteristicIds.ledPitchId {
      let intValue = Int(input) ?? -1
      return CharacteristicInputError(success: intValue == 3 || intValue == 4, error: "Must be 3 or 4")
    } else if myId == CharacteristicIds.speedThresholdId {
      let split = input.split(separator: ",")
      if split.count != 2 {
        return CharacteristicInputError(success: false, error: "Must have 2 values, each >= 0, < 10, and < 3 digits")
      }
      var allGood = true
      for digit in split {
        let doubleValue = Double(digit) ?? -1.0
        let format = "0.00"
        if !(digit.count <= format.count && doubleValue < 10 && doubleValue >= 0) {
          allGood = false
        }
      }
      
      return CharacteristicInputError(success: allGood, error: "Each number must be >= 0, < 10, and < 3 digits")
    } else if myId == CharacteristicIds.connectTimeoutId {
      let intValue = Int(input) ?? -1
      return CharacteristicInputError(success: intValue >= 0 && intValue <= 999, error: "Must be >= 0 and <= 1000")
    } else if myId == CharacteristicIds.imu1Id || myId == CharacteristicIds.imu2Id {
      let split = input.split(separator: ",")
      if split.count != 6 {
        return CharacteristicInputError(success: false, error: "Must have 6 values!")
      }
      
      return CharacteristicInputError(success: true, error: "Must have 6 values!")
    } else {
      //TODO: Add 'em all
      return CharacteristicInputError(success: false, error: "Can't update this value (yet)...")
    }
  }
}
