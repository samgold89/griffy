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

extension CBCharacteristic {
  func griffyValue() -> Array<Any>? {//[Int]? {
    let uiint16Ids = [CharacteristicAlu1Id,CharacteristicAlu2Id,CharacteristicWheelspeedId,CharacteristicConnecttimeoutId]
    let uiint16ArrayIds = [CharacteristicTemperatureId, CharacteristicInstantcurrentId, CharacteristicAveragecurrentId, CharacteristicVoltageId, CharacteristicSecondsremainingId, CharacteristicPercentagechargeId, CharacteristicMahremainingId]
    let uiint32Ids = [CharacteristicHardwareversionId, CharacteristicFirmwareversionId]
    let uiint8ids = [CharacteristicLedpitchId, CharacteristicImu1Id, CharacteristicImu2Id, CharacteristicStatusId, CharacteristicImageselectId, CharacteristicImageeraseId, CharacteristicTestId]
    let uiint8ArrayIds = [CharacteristicImageloadId, CharacteristicSpeedthresholdId, CharacteristicBrightnessId]
    let serialId = [CharacteristicSerialnumberId]
    
    guard let data = value else {
//      assertionFailure("Characteristic.value is not coming back with any data...")
      return nil
    }
    
    let uuidString = uuid.uuidString
    if uiint16Ids.contains(uuidString) {
      return [Int(data.uint16)]
    } else if uiint32Ids.contains(uuidString) {
      return [Int(data.uint32)]
    } else if uiint8ids.contains(uuidString) {
      return [Int(data.uint8)]
    } else if uiint8ArrayIds.contains(uuidString) {
      var array = [Int]()
      data.forEach({ (int8byte) in
        array.append(Int(int8byte))
      })
      return array
    } else if uiint16ArrayIds.contains(uuidString) {
      var array = [Int]()
      var idx = 0
      while idx < data.count-1 {
        let chunk1 = Data(bytes: [data[idx],data[idx+1]], count: 2)
        array.append(Int(chunk1.uint16))
        idx += 2
      }
      return array
    } else if serialId.contains(uuidString) {
      var array = [Int]()
      data.forEach({ (int8byte) in
        let string = "\(Character(UnicodeScalar(UInt32("\(Int(int8byte).toDecimal())", radix: 16)!)!))"
        array.append(Int(string)!)
      })
      
      let joinedArray = [(array.compactMap { $0 == nil ? nil : String($0!) }).joined()]
      return joinedArray
    } else {
      assertionFailure("Not handling the parsing of some kind of thing.")
      return [0]
    }
  }
  
  func griffyName() -> String {
    return characteristicNameById[uuid.uuidString] ?? "Missing Name!"
  }
}
