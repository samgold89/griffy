//
//  DataExtensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/15/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation

extension Data {
  var wheelMemoryItem: AdMemoryMap.WheelMemoryItem? {
    let mem = try? PropertyListDecoder().decode(AdMemoryMap.WheelMemoryItem.self, from: self)
    assert(mem != nil)
    return mem
  }
}

extension Data {
  func griffyDisplayValue(characteristicId: String) -> String {
    var arrayString = [String]()
    let bleObject = BLEConstants.gfBleObjects.first(where: { $0.uuid == characteristicId })
    
    if characteristicId == CharacteristicIds.imu1Id || characteristicId == CharacteristicIds.imu2Id {
      var array = [String]()
      var idx = 0
      while idx < self.count-1 {
        let chunk1 = Data(bytes: [self[idx],self[idx+1]], count: 2)
        array.append("\(Int(chunk1.uint16))")
        idx += 2
      }
      arrayString = array
    } else if bleObject?.parseDataType == .uint16 {
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
    } else if bleObject?.parseDataType == .uint32 {
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
    } else if bleObject?.parseDataType == .uint8 {
      arrayString = ["\(Int(self.uint8))"]
    } else if bleObject?.parseDataType == .uint8array {
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
    } else if bleObject?.parseDataType == .uint16array {
      var array = [String]()
      var idx = 0
      while idx < self.count-1 {
        let chunk1 = Data(bytes: [self[idx],self[idx+1]], count: 2)
        let intValue = Int(chunk1.uint16)
        
        if [CharacteristicIds.voltageId, CharacteristicIds.evVoltage].contains(characteristicId) {
          array.append(String(format: "%0.1f", Float(intValue)/1000.0))
        } else if [].contains(characteristicId) {
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
    } else if bleObject?.parseDataType == .serial {
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
