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
}

struct CharacteristicIds {
  static let serialNumberId = "21B8E697-AFA0-43A2-BF36-831285BFAB66"
  static let hardwareVersionId = "AAAE5188-3AD3-43A3-A0B4-DEC44E7C4680"
  static let firmwareVersionId = "A7173297-3A7C-4937-A450-D405CD7EB2CE"
  static let ledPitchId = "E2784DBE-8020-4AF7-8AA7-E8A9BDCCEF13"
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
}

public let characteristicNameById: [String: String] = ["CD205203-029F-459B-B015-D93A554C035C":"device",
                                 "21B8E697-AFA0-43A2-BF36-831285BFAB66":"serial Number",
                                 "AAAE5188-3AD3-43A3-A0B4-DEC44E7C4680":"hardware Version",
                                 "A7173297-3A7C-4937-A450-D405CD7EB2CE":"firmware Version",
                                 "E2784DBE-8020-4AF7-8AA7-E8A9BDCCEF13":"led Pitch",
                                 "53079CA5-1E15-4405-8DC3-052B3B4EC2E5":"status",
                                 "C5AA4192-2B0C-4676-AE68-6A7E15F3B943":"imu1",
                                 "D5EDC2C5-DD26-456B-A4E9-D692D48713CB":"imu2",
                                 "BA8C839A-5157-425C-B4BA-39865B18670B":"alu1",
                                 "427195F5-8ACC-48A0-A155-D045CC5C47CA":"alu2",
                                 "D8AFC950-E229-414B-BF30-3EC23264535E":"status",
                                 "353A780E-468D-4A02-8F9A-3A7BC0C502D0":"Speed",
                                 "3BBB8E76-5E5D-42AF-A7A0-858AC051B069":"settings",
                                 "84B749D2-AD90-47C1-A18E-BD3927AC80E1":"connect Timeout",
                                 "900D5F97-D291-4E05-9F6C-3B4537A71E9F":"display",
                                 "B03EE9AE-F2EC-4829-812D-182EDD2F9C53":"image Load",
                                 "FDC342B7-00E9-427F-9AF5-7A1CA5097468":"Image",
                                 "BBCF9D7A-8A2F-4A2F-960A-8A583019D7E5":"image Erase",
                                 "68E78595-01E2-4F79-9BF3-552D0B63CC95":"test",
                                 "77ADBD1E-D5B8-4392-9370-D0D8E1290682":"Threshold",
                                 "29B73168-FE26-47B9-9811-6D90C4A45A2D":"brightness",
                                 "46F575E3-B6A4-4708-BCDD-8C7DFD64EFB3":"battery",
                                 "2BBF1805-F7A3-4694-8D48-F12F88E7CE81":"Temperature (C)",
                                 "C10B005E-94A3-4A9F-9693-2422B9A28DF8":"Instant current (A)",
                                 "E0AE6145-CA28-4FC1-AB08-100531027980":"Average current (A)",
                                 "15623E29-D7A2-4ABA-99B6-0A672329C33B":"Voltage (V)",
                                 "21E54027-36E5-4528-ABF1-2C02539DFEC0":"Time remaining",
                                 "A3584E8C-68F5-4FB9-801C-671A634333A1":"Battery %",
                                 "5A241FE8-26B3-4504-A0E7-E6ECCCFD2892":"mah Remaining"]
