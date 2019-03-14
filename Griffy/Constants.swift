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
  static let lastBrightness = "lastBrightness"
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
  static let temperatureId = "2BBF1805-F7A3-4694-8D48-F12F88E7CE81"
  static let instantCurrentId = "C10B005E-94A3-4A9F-9693-2422B9A28DF8"
  static let averageCurrentId = "E0AE6145-CA28-4FC1-AB08-100531027980"
  static let voltageId = "15623E29-D7A2-4ABA-99B6-0A672329C33B"
  static let secondsRemainingId = "21E54027-36E5-4528-ABF1-2C02539DFEC0"
  static let percentageChargeId = "A3584E8C-68F5-4FB9-801C-671A634333A1"
  static let mahRemainingId = "5A241FE8-26B3-4504-A0E7-E6ECCCFD2892"
  static let animationId = "57CBF2A3-5BFF-4DAB-8A35-940B3D63BDC0"
  static let frameCountId = "823B1226-EBD0-4B78-BE04-19DD5234F7C8"
  static let frameDurationId = "AD8A2930-F094-454C-99E8-618DF45D256C"
  static let dumTest1 = "9A681C49-919E-488E-9987-E821E91612B4"
  static let dumTest2 = "668BAA75-3E1C-4E75-8926-9F8A5E7C438C"
  static let dumTest3 = "E1BF8535-C930-4DD3-9AC6-8B53133E68A2"
  static let dumTest4 = "F089C654-2E28-4B2D-A7A6-4A43808AA1D1"
  static let dumTest5 = "59DE55B3-33F8-4DD4-9559-66C5BA1EAEAA"
  static let dumTest6 = "8CF9B0D9-D0BE-4FF8-994C-6961FD022B15"
  static let dumTest7 = "4A0AB681-855E-4F7A-A6EB-45E9354B33E3"
  static let dumTest8 = "ADB9655E-73F9-4F06-BB83-52098030E2D1"
  static let dumTest9 = "D7F2298C-C357-4E9F-8546-3F9F3EC3941D"
  static let lastFramePlayCount = "88109ADB-EDFD-49DD-AA9A-7032ECC4EBD2"
}

let uiint16Ids = [CharacteristicIds.alu1Id,CharacteristicIds.alu2Id,CharacteristicIds.wheelSpeedId,CharacteristicIds.connectTimeoutId, CharacteristicIds.frameDurationId]
let uiint16ArrayIds = [CharacteristicIds.temperatureId, CharacteristicIds.instantCurrentId, CharacteristicIds.averageCurrentId, CharacteristicIds.voltageId, CharacteristicIds.secondsRemainingId, CharacteristicIds.percentageChargeId, CharacteristicIds.mahRemainingId]
let uiint32Ids = [CharacteristicIds.hardwareVersionId, CharacteristicIds.firmwareVersionId]
let uiint8ids = [CharacteristicIds.isReversedId, CharacteristicIds.imu1Id, CharacteristicIds.imu2Id, CharacteristicIds.statusId, CharacteristicIds.imageSelectId, CharacteristicIds.imageEraseId, CharacteristicIds.testId, CharacteristicIds.animationId, CharacteristicIds.frameCountId, CharacteristicIds.dumTest1, CharacteristicIds.dumTest2, CharacteristicIds.dumTest3, CharacteristicIds.dumTest4, CharacteristicIds.dumTest5, CharacteristicIds.dumTest6, CharacteristicIds.dumTest7, CharacteristicIds.dumTest8,CharacteristicIds.dumTest9, CharacteristicIds.lastFramePlayCount]
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
                                             CharacteristicIds.temperatureId,
                                             CharacteristicIds.instantCurrentId,
                                             CharacteristicIds.averageCurrentId,
                                             CharacteristicIds.voltageId,
                                             CharacteristicIds.secondsRemainingId,
                                             CharacteristicIds.percentageChargeId,
                                             CharacteristicIds.mahRemainingId,
                                             CharacteristicIds.animationId,
                                             CharacteristicIds.frameCountId,
                                             CharacteristicIds.frameDurationId,
                                             CharacteristicIds.dumTest2,
                                             CharacteristicIds.dumTest3,
                                             CharacteristicIds.dumTest4,
                                             CharacteristicIds.dumTest5,
                                             CharacteristicIds.dumTest6,
                                             CharacteristicIds.dumTest7,
                                             CharacteristicIds.dumTest8,
                                             CharacteristicIds.dumTest9,
                                             CharacteristicIds.lastFramePlayCount
]

public let characteristicNameById: [String: String] = [ServiceIds.deviceId:"device",
                                 CharacteristicIds.serialNumberId:"serial Number",
                                 CharacteristicIds.hardwareVersionId:"hardware Version",
                                 CharacteristicIds.firmwareVersionId:"firmware Version",
                                 CharacteristicIds.isReversedId:"Is Reversed",
                                 CharacteristicIds.statusId:"status",
                                 CharacteristicIds.imu1Id:"imu1",
                                 CharacteristicIds.imu2Id:"imu2",
                                 CharacteristicIds.alu1Id:"alu1",
                                 CharacteristicIds.alu2Id:"alu2",
                                 ServiceIds.statusId:"status",
                                 CharacteristicIds.wheelSpeedId:"Speed",
                                 ServiceIds.settingsId:"settings",
                                 CharacteristicIds.connectTimeoutId:"connect Timeout",
                                 ServiceIds.displayId:"display",
                                 CharacteristicIds.imageLoadId:"image Load",
                                 CharacteristicIds.imageSelectId:"Image",
                                 CharacteristicIds.imageEraseId:"image Erase",
                                 CharacteristicIds.testId:"test",
                                 CharacteristicIds.speedThresholdId:"Threshold",
                                 CharacteristicIds.brightnessId:"brightness",
                                 ServiceIds.batteryId:"battery",
                                 CharacteristicIds.temperatureId:"Temperature (C)",
                                 CharacteristicIds.instantCurrentId:"Instant current (A)",
                                 CharacteristicIds.averageCurrentId:"Average current (A)",
                                 CharacteristicIds.voltageId:"Voltage (V)",
                                 CharacteristicIds.secondsRemainingId:"Time remaining",
                                 CharacteristicIds.percentageChargeId:"Battery %",
                                 CharacteristicIds.mahRemainingId:"mah Remaining",
                                 CharacteristicIds.animationId: "Is Animated",
                                 CharacteristicIds.frameCountId: "Frame Count",
                                 CharacteristicIds.frameDurationId: "Frame Duration",
                                 CharacteristicIds.dumTest1: "Test 1",
                                 CharacteristicIds.dumTest2: "Test 2",
                                 CharacteristicIds.dumTest3: "Test 3",
                                 CharacteristicIds.dumTest4: "Test 4",
                                 CharacteristicIds.dumTest5: "Test 5",
                                 CharacteristicIds.dumTest6: "Test 6",
                                 CharacteristicIds.dumTest7: "Test 7",
                                 CharacteristicIds.dumTest8: "Test 8",
                                 CharacteristicIds.dumTest9: "Test 9",
                                 CharacteristicIds.lastFramePlayCount: "Last Frame Play Count"
]
