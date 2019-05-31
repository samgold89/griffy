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
//isReversed
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
  func griffyDisplayValue(characteristicId: String) -> String {
    var arrayString = [String]()
    
    if characteristicId == CharacteristicIds.imu1Id || characteristicId == CharacteristicIds.imu2Id {
      var array = [String]()
      var idx = 0
      while idx < self.count-1 {
        let chunk1 = Data(bytes: [self[idx],self[idx+1]], count: 2)
        array.append("\(Int(chunk1.uint16))")
        idx += 2
      }
      arrayString = array
    } else if uiint16Ids.contains(characteristicId) {
      let valueInt = Int(self.uint16)
      
      if characteristicId == CharacteristicIds.wheelSpeedId {
        let rpsVal = Float(valueInt)/100.0
        arrayString = [String(format: "%0.2f rps, %0.1f mph", rpsVal, 5.0*rpsVal)]
      } else if [CharacteristicIds.alu1Id,CharacteristicIds.alu2Id].contains(characteristicId) {
        let baseValue = valueInt%4096
        let exponent = (valueInt-baseValue)/4096
        arrayString.append("\(baseValue) e\(exponent)")
      } else {
        arrayString = ["\(valueInt)"]
      }
    } else if uiint32Ids.contains(characteristicId) {
      let intValue = Int(self.uint32)
      if characteristicId == CharacteristicIds.firmwareVersionId {
        let remainder = intValue % 65536
        let byteTwo = (intValue - remainder)/65536
        let byteZero = remainder % 256
        let byteOne = (remainder - byteZero)/256
        arrayString = ["\(byteTwo).\(byteOne).\(byteZero)"]
      } else {
        arrayString = ["\(intValue)"]
      }
    } else if uiint8ids.contains(characteristicId) {
      arrayString = ["\(Int(self.uint8))"]
    } else if uiint8ArrayIds.contains(characteristicId) {
      var array = [String]()
      self.forEach({ (int8byte) in
        let valueInt = Int(int8byte)
        if characteristicId == CharacteristicIds.speedThresholdId {
          let rpsVal = Float(valueInt)/100.0
          array.append(String(format: "%0.2f", rpsVal))
        } else {
          array.append("\(valueInt)")
        }
      })
      arrayString = array
    } else if uiint16ArrayIds.contains(characteristicId) {
      var array = [String]()
      var idx = 0
      while idx < self.count-1 {
        let chunk1 = Data(bytes: [self[idx],self[idx+1]], count: 2)
        let intValue = Int(chunk1.uint16)
        
        if [CharacteristicIds.temperatureId, CharacteristicIds.instantCurrentId, CharacteristicIds.averageCurrentId, CharacteristicIds.voltageId].contains(characteristicId) {
          array.append(String(format: "%0.1f", Float(intValue)/1000.0))
        } else if [CharacteristicIds.secondsRemainingId].contains(characteristicId) {
          array.append(intValue.toTimeString())
        } else {
          array.append("\(intValue)")
        }
        idx += 2
      }
      
//      if characteristicId == CharacteristicIds.instantCurrentId {
//        array.append(GFCharacteristic.watts)
//      }
      
      arrayString = array
    } else if serialId.contains(characteristicId) {
      var array = [String]()
      self.forEach({ (int8byte) in
        let string = "\(Character(UnicodeScalar(UInt32("\(Int(int8byte).toDecimal())", radix: 16)!)!))"
        array.append(string)
      })
      
      let joinedArray = [(array.compactMap { $0 == nil ? nil : String($0!) }).joined()]
      arrayString = joinedArray
    } else {
      assertionFailure("Not handling the parsing of some kind of thing.")
      arrayString = ["👎🏽"]
    }
    
    var string = ""
    var i = 0
    for element in arrayString {
      string += (i == 0 ? element : ", \(element)")
      i += 1
    }
    return string
  }
}
extension CBCharacteristic {
  func griffyDisplayValue() -> String {
    return value?.griffyDisplayValue(characteristicId: uuid.uuidString) ?? "🤦‍♀️"
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
    } else if myId == CharacteristicIds.isReversedId {
      let intValue = Int(input) ?? -1
      return CharacteristicInputError(success: intValue == 0 || intValue == 1, error: "Must be 0 or 1")
    } else if myId == CharacteristicIds.speedThresholdId {
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
    } else if myId == CharacteristicIds.connectTimeoutId {
      let intValue = Int(input) ?? -1
      return CharacteristicInputError(success: intValue >= 0, error: "Must be >= 0")
    } else if myId == CharacteristicIds.imu1Id || myId == CharacteristicIds.imu2Id {
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
