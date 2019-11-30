//
//  Constants.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/17/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

struct PeripheralIds {
  static let griffy = "ACE9A76A-DF76-B541-5699-8341D9C853A8"
}

struct ServiceIds {
  static let allIds = [ServiceIds.deviceId.cbuuid(), ServiceIds.statusId.cbuuid(), ServiceIds.settingsId.cbuuid(), ServiceIds.displayId.cbuuid(), ServiceIds.batteryId.cbuuid()]
  
  static let deviceId = "CD205203-029F-459B-B015-D93A554C035C"
  static let statusId = "53079CA5-1E15-4405-8DC3-052B3B4EC2E5"
  static let settingsId = "3BBB8E76-5E5D-42AF-A7A0-858AC051B069"
  static let displayId = "900D5F97-D291-4E05-9F6C-3B4537A71E9F"
  static let batteryId = "46F575E3-B6A4-4708-BCDD-8C7DFD64EFB3"
}

struct UserDefaultConstants {
  static let activeClientName = "activeClientName"
  static let lastSelectedImageIndex = "lastSelectedImageIndex"
  static let maxOutgoingBLERequests = "maxOutgoingBLERequests"
  static let activeImageData = "activeImageData"
  static let activeIndex = "activeIndex"
  static let lastLeftBrightness = "lastLeftBrightness"
  static let lastRightBrightness = "lastRightBrightness"
}

struct CharacteristicIds {
  static let serialNumberId = "21B8E697-AFA0-43A2-BF36-831285BFAB66"
  static let hardwareVersionId = "AAAE5188-3AD3-43A3-A0B4-DEC44E7C4680"
  static let firmwareVersionId = "A7173297-3A7C-4937-A450-D405CD7EB2CE"
  static let isReversedId = "E2784DBE-8020-4AF7-8AA7-E8A9BDCCEF13"
  static let imu1Id = "C5AA4192-2B0C-4676-AE68-6A7E15F3B943"
  static let imu2Id = "D5EDC2C5-DD26-456B-A4E9-D692D48713CB"
  static let alu1Id = "BA8C839A-5157-425C-B4BA-39865B18670B"
  static let alu2Id = "427195F5-8ACC-48A0-A155-D045CC5C47CA"
  static let statusId = "D8AFC950-E229-414B-BF30-3EC23264535E"
  static let wheelSpeedId = "353A780E-468D-4A02-8F9A-3A7BC0C502D0"
  static let connectTimeoutId = "84B749D2-AD90-47C1-A18E-BD3927AC80E1"
  static let imageLoadId = "B03EE9AE-F2EC-4829-812D-182EDD2F9C53"
  static let imageSelectId = "FDC342B7-00E9-427F-9AF5-7A1CA5097468"
  static let imageEraseId = "BBCF9D7A-8A2F-4A2F-960A-8A583019D7E5"
  static let testId = "68E78595-01E2-4F79-9BF3-552D0B63CC95"
  static let speedThresholdId = "77ADBD1E-D5B8-4392-9370-D0D8E1290682"
  static let brightnessId = "29B73168-FE26-47B9-9811-6D90C4A45A2D"
  static let voltageId = "15623E29-D7A2-4ABA-99B6-0A672329C33B"
  static let animationId = "57CBF2A3-5BFF-4DAB-8A35-940B3D63BDC0"
  static let frameCountId = "823B1226-EBD0-4B78-BE04-19DD5234F7C8"
  static let frameDurationId = "AD8A2930-F094-454C-99E8-618DF45D256C"
  static let isHighResolutionId = "7F88536D-2F3C-4EC3-B47E-AF162D19F89A"
  static let evBattery = "B1F9E355-87FF-4FBE-9F62-A7C2E7A249F0"
  static let evVoltage = "CFBDDB18-ECCB-4F26-9A0D-53D01B4366E5"
  
  static let dumTest1 = "9A681C49-919E-488E-9987-E821E91612B4"
  static let dumTest2 = "668BAA75-3E1C-4E75-8926-9F8A5E7C438C"
  static let dumTest3 = "E1BF8535-C930-4DD3-9AC6-8B53133E68A2"
  static let dumTest4 = "F089C654-2E28-4B2D-A7A6-4A43808AA1D1"
  static let dumTest5 = "59DE55B3-33F8-4DD4-9559-66C5BA1EAEAA"
  static let dumTest6 = "8CF9B0D9-D0BE-4FF8-994C-6961FD022B15"
  static let dumTest7 = "4A0AB681-855E-4F7A-A6EB-45E9354B33E3"
  static let dumTest8 = "ADB9655E-73F9-4F06-BB83-52098030E2D1"
  static let dumTest9 = "D7F2298C-C357-4E9F-8546-3F9F3EC3941D"
  
  //These tests are UInt 16
  static let dumTest10 = "1793715A-8823-4F89-809A-DFC801836EB0"
  static let dumTest11 = "7E31DDFB-2057-4F1D-A8C3-BA69E9C761BC"
  static let dumTest12 = "E322C8DB-FE30-419F-90F5-79513AEC21C7"
  static let dumTest13 = "46FE9BA6-0D35-46CE-817F-2D1D9074A476"
  static let dumTest14 = "B774B25C-A610-44A8-9C05-3765EAC75948"
  static let dumTest15 = "527FE1EE-33A8-4EF6-B5D2-24ED09A9D292"
  static let dumTest16 = "9F8F8905-479A-43E4-A6CD-5FD3D82B4FDE"
  static let dumTest17 = "2B1782C0-7E0F-4E47-8787-E60A82CDF4DF"
  static let lastFramePlayCount = "88109ADB-EDFD-49DD-AA9A-7032ECC4EBD2"
}

let uiint16Ids = [CharacteristicIds.alu1Id,CharacteristicIds.alu2Id,CharacteristicIds.wheelSpeedId,CharacteristicIds.connectTimeoutId, CharacteristicIds.frameDurationId, CharacteristicIds.dumTest10, CharacteristicIds.dumTest11, CharacteristicIds.dumTest12, CharacteristicIds.dumTest13, CharacteristicIds.dumTest14, CharacteristicIds.dumTest15, CharacteristicIds.dumTest16, CharacteristicIds.dumTest17, CharacteristicIds.imageSelectId, CharacteristicIds.imageEraseId, CharacteristicIds.evVoltage] //TODO UInt8Changes
let uiint16ArrayIds = [CharacteristicIds.voltageId]
let uiint32Ids = [CharacteristicIds.hardwareVersionId, CharacteristicIds.firmwareVersionId]
let uiint8ids = [CharacteristicIds.isReversedId, CharacteristicIds.imu1Id, CharacteristicIds.imu2Id, CharacteristicIds.statusId, CharacteristicIds.testId, CharacteristicIds.animationId, CharacteristicIds.frameCountId, CharacteristicIds.dumTest1, CharacteristicIds.dumTest2, CharacteristicIds.dumTest3, CharacteristicIds.dumTest4, CharacteristicIds.dumTest5, CharacteristicIds.dumTest6, CharacteristicIds.dumTest7, CharacteristicIds.dumTest8,CharacteristicIds.dumTest9, CharacteristicIds.lastFramePlayCount, CharacteristicIds.isHighResolutionId, CharacteristicIds.evBattery]//, CharacteristicIds.imageSelectId, CharacteristicIds.imageEraseId] //TODO UInt8Changes
let uiint8ArrayIds = [CharacteristicIds.imageLoadId, CharacteristicIds.speedThresholdId, CharacteristicIds.brightnessId]
let serialId = [CharacteristicIds.serialNumberId]

public let ReadableCharacterIds: [String] = [CharacteristicIds.serialNumberId,
                                             CharacteristicIds.hardwareVersionId,
                                             CharacteristicIds.firmwareVersionId,
                                             CharacteristicIds.isReversedId,
                                             CharacteristicIds.imu1Id,
                                             CharacteristicIds.alu1Id,
                                             CharacteristicIds.connectTimeoutId,
                                             CharacteristicIds.speedThresholdId,
                                             CharacteristicIds.brightnessId,
                                             CharacteristicIds.voltageId,
                                             CharacteristicIds.animationId,
                                             CharacteristicIds.frameCountId,
                                             CharacteristicIds.frameDurationId,
                                             CharacteristicIds.evBattery,
                                             CharacteristicIds.evVoltage,
                                             CharacteristicIds.dumTest2,
                                             CharacteristicIds.dumTest3,
                                             CharacteristicIds.dumTest4,
                                             CharacteristicIds.dumTest5,
                                             CharacteristicIds.dumTest6,
                                             CharacteristicIds.dumTest7,
                                             CharacteristicIds.dumTest8,
                                             CharacteristicIds.dumTest9,
                                             CharacteristicIds.dumTest10,
                                             CharacteristicIds.dumTest11,
                                             CharacteristicIds.dumTest12,
                                             CharacteristicIds.dumTest13,
                                             CharacteristicIds.dumTest14,
                                             CharacteristicIds.dumTest15,
                                             CharacteristicIds.dumTest16,
                                             CharacteristicIds.dumTest17,
                                             CharacteristicIds.lastFramePlayCount,
                                             CharacteristicIds.isHighResolutionId
]

public let characteristicNameById: [String: String] = [
  ServiceIds.deviceId:"device",
  ServiceIds.statusId:"status",
  ServiceIds.settingsId:"settings",
  ServiceIds.displayId:"display",
  ServiceIds.batteryId:"battery",
  CharacteristicIds.serialNumberId:"serial Number",
  CharacteristicIds.hardwareVersionId:"hardware Version",
  CharacteristicIds.firmwareVersionId:"firmware Version",
  CharacteristicIds.isReversedId:"Is Reversed",
  CharacteristicIds.statusId:"status",
  CharacteristicIds.imu1Id:"imu1",
  CharacteristicIds.imu2Id:"imu2",
  CharacteristicIds.alu1Id:"alu1",
  CharacteristicIds.alu2Id:"alu2",
  CharacteristicIds.wheelSpeedId:"Speed",
  CharacteristicIds.connectTimeoutId:"connect Timeout",
  CharacteristicIds.imageLoadId:"image Load",
  CharacteristicIds.imageSelectId:"Image",
  CharacteristicIds.imageEraseId:"image Erase",
  CharacteristicIds.testId:"test",
  CharacteristicIds.speedThresholdId:"Threshold",
  CharacteristicIds.brightnessId:"brightness",
  CharacteristicIds.voltageId:"Voltage (V)",
  CharacteristicIds.animationId: "Is Animated",
  CharacteristicIds.frameCountId: "Frame Count",
  CharacteristicIds.frameDurationId: "Frame Duration",
  CharacteristicIds.evVoltage: "EV Voltage",
  CharacteristicIds.evBattery: "EV Battery",
  CharacteristicIds.dumTest1: "Test 1",
  CharacteristicIds.dumTest2: "Test 2",
  CharacteristicIds.dumTest3: "Test 3",
  CharacteristicIds.dumTest4: "Test 4",
  CharacteristicIds.dumTest5: "Test 5",
  CharacteristicIds.dumTest6: "Test 6",
  CharacteristicIds.dumTest7: "Test 7",
  CharacteristicIds.dumTest8: "Test 8",
  CharacteristicIds.dumTest9: "Test 9",
  CharacteristicIds.dumTest10: "Test16a",
  CharacteristicIds.dumTest11: "Test16b",
  CharacteristicIds.dumTest12: "Test16c",
  CharacteristicIds.dumTest13: "Test16d",
  CharacteristicIds.dumTest14: "Test16e",
  CharacteristicIds.dumTest15: "Test16f",
  CharacteristicIds.dumTest16: "Test16g",
  CharacteristicIds.dumTest17: "Test16h",
  CharacteristicIds.lastFramePlayCount: "Last Frame Play Count",
  CharacteristicIds.isHighResolutionId: "High Resolution"
]
