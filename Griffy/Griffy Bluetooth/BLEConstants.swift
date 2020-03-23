//
//  Constants.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/17/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import UIKit

class BLEConstants {
  enum GFBLEObjectType {
    case peripheral
    case service
    case characteristic
  }
  
  enum GFDataParseType {
    case uint16
    case uint16array
    case uint32
    case uint8
    case uint8array
    case asciiString
  }
  
  struct GFBLEObject {
    var type: GFBLEObjectType
    var uuid: String
    var parseDataType: GFDataParseType?
    var displayName: String
    var isReadable: Bool
    
    func dataValue(fromInt int: Int) -> Data {
      switch parseDataType {
      case .uint8:
        return UInt8(int).data
      case .uint16:
        return UInt16(int).data
      case .uint32:
        return UInt32(int).data
      case .uint8array, .uint16array, .asciiString, .none:
        assertionFailure("No value available")
        return Data()
      }
    }

    var isUInt8: Bool {
      return parseDataType == .uint8 || parseDataType == .uint8array
    }
    
    var isUInt16: Bool {
      return parseDataType == .uint16 || parseDataType == .uint16array
    }
    
    var isUInt32: Bool {
      return parseDataType == .uint32
    }
  }
  
  public static var gfBleObjects: [GFBLEObject] {
    var all = [GFBLEObject]()
    
    //MARK: Peripherals
    all.append(GFBLEObject(type: .peripheral,
                           uuid: "ACE9A76A-DF76-B541-5699-8341D9C853A8",
                           parseDataType: .none,
                           displayName: "Griffy Peripheral",
                           isReadable: false))
    
    //MARK: Services
    all.append(GFBLEObject(type: .service,
                           uuid: "CD205203-029F-459B-B015-D93A554C035C",
                           parseDataType: .none,
                           displayName: "Device",
                           isReadable: false))
    
    all.append(GFBLEObject(type: .service,
                           uuid: "53079CA5-1E15-4405-8DC3-052B3B4EC2E5",
                           parseDataType: .none,
                           displayName: "Status",
                           isReadable: false))
    
    all.append(GFBLEObject(type: .service,
                           uuid: "3BBB8E76-5E5D-42AF-A7A0-858AC051B069",
                           parseDataType: .none,
                           displayName: "Settings",
                           isReadable: false))
    
    all.append(GFBLEObject(type: .service,
                           uuid: "900D5F97-D291-4E05-9F6C-3B4537A71E9F",
                           parseDataType: .none,
                           displayName: "Display",
                           isReadable: false))
    
    all.append(GFBLEObject(type: .service,
                           uuid: "46F575E3-B6A4-4708-BCDD-8C7DFD64EFB3",
                           parseDataType: .none,
                           displayName: "Battery",
                           isReadable: false))
    
    //MARK: Characteristics
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.serialNumberId,
                           parseDataType: .asciiString,
                           displayName: "Serial Number",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.hardwareVersionId,
                           parseDataType: .uint8array,
                           displayName: "Hardware Version",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.firmwareVersionId,
                           parseDataType: .uint32,
                           displayName: "Firmware Version",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.isReversedId,
                           parseDataType: .uint8array,
                           displayName: "Is Reversed",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.statusId,
                           parseDataType: .uint8array,
                           displayName: "Status",
                           isReadable: false))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.imu1Id,
                           parseDataType: .uint8array,
                           displayName: "imu1",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.imu2Id,
                           parseDataType: .uint8array,
                           displayName: "imu2",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.alu1Id,
                           parseDataType: .uint16,
                           displayName: "alu1",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.alu2Id,
                           parseDataType: .uint16,
                           displayName: "alu2",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.wheelSpeedId,
                           parseDataType: .uint16,
                           displayName: "Wheel Speed",
                           isReadable: false))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.connectTimeoutId,
                           parseDataType: .uint16,
                           displayName: "Connect Timeout",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.imageLoadId,
                           parseDataType: .uint8array,
                           displayName: "Image Load",
                           isReadable: false))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.imageSelectId,
                           parseDataType: .uint16,
                           displayName: "Image Select",
                           isReadable: false))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.imageEraseId,
                           parseDataType: .uint16,
                           displayName: "Image Erase",
                           isReadable: false))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.testId,
                           parseDataType: .uint8array,
                           displayName: "Test",
                           isReadable: false))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.speedThresholdId,
                           parseDataType: .uint8array,
                           displayName: "Threshold",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.brightnessId,
                           parseDataType: .uint8array,
                           displayName: "Brightness",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.voltageId,
                           parseDataType: .uint16array,
                           displayName: "Voltage (V)",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.animationId,
                           parseDataType: .uint8array,
                           displayName: "Is Animated",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.frameCountId,
                           parseDataType: .uint8array,
                           displayName: "Frame Count",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.frameDurationId,
                           parseDataType: .uint16,
                           displayName: "Frame Duration",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.isHighResolutionId,
                           parseDataType: .uint8array,
                           displayName: "Is Hi-Resolution",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.evVoltage,
                           parseDataType: .uint16array,
                           displayName: "EV Voltage",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.evBattery,
                           parseDataType: .uint8,
                           displayName: "EV Battery",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.orientation,
                           parseDataType: .uint16,
                           displayName: "Orientation",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.lastFramePlayCount,
                           parseDataType: .uint8array,
                           displayName: "Last Frame Play Count",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.displayFormat,
                           parseDataType: .uint8array,
                           displayName: "Display Format",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.activeLog,
                           parseDataType: .uint8,
                           displayName: "Active Log",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.logClockTickReset,
                           parseDataType: .uint8,
                           displayName: "Log Clock Tick",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.loggingPeriod,
                           parseDataType: .uint16,
                           displayName: "Log Active Log",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.logMemCount0,
                           parseDataType: .uint32,
                           displayName: "Log MemCount 0",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.logMemCount1,
                           parseDataType: .uint32,
                           displayName: "Log MemCount 1",
                           isReadable: true))
    
    //MARK: Test Characteristics
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest1,
                           parseDataType: .uint8,
                           displayName: "Test 1",
                           isReadable: false)) // Should this be readable!?
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest2,
                           parseDataType: .uint8array,
                           displayName: "Test 2",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest3,
                           parseDataType: .uint8array,
                           displayName: "Test 3",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest4,
                           parseDataType: .uint8array,
                           displayName: "Test 4",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest5,
                           parseDataType: .uint8array,
                           displayName: "Test 5",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest6,
                           parseDataType: .uint8array,
                           displayName: "Test 6",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest7,
                           parseDataType: .uint8array,
                           displayName: "Test 7",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest8,
                           parseDataType: .uint8array,
                           displayName: "Test 8",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest9,
                           parseDataType: .uint8array,
                           displayName: "Test 9",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest10int8,
                           parseDataType: .uint8,
                           displayName: "Test 10",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest10,
                           parseDataType: .uint16,
                           displayName: "Test16a",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest11,
                           parseDataType: .uint16,
                           displayName: "Test16b",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest12,
                           parseDataType: .uint16,
                           displayName: "Test16c",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest13,
                           parseDataType: .uint16,
                           displayName: "Test16d",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest14,
                           parseDataType: .uint16,
                           displayName: "Test16e",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest15,
                           parseDataType: .uint16,
                           displayName: "Test16f",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest16,
                           parseDataType: .uint16,
                           displayName: "Test16g",
                           isReadable: true))
    
    all.append(GFBLEObject(type: .characteristic,
                           uuid: BLEConstants.CharacteristicIds.dumTest17,
                           parseDataType: .uint16,
                           displayName: "Test16h",
                           isReadable: true))
    
    return all
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
    static let orientation = "D6782FCF-9D36-42C4-B533-854337C12BEB"
    static let displayFormat = "A03B3301-D050-40B8-911F-4D20B5C9BA3F"
    
    // Logging
    static let connectTimeoutId = "84B749D2-AD90-47C1-A18E-BD3927AC80E1"
    static let activeLog = "CBFA3971-5BD5-4FB1-B379-DF6091A608D4"
    static let logClockTickReset = "D4154C5A-8DFC-4F75-8D82-B40542B60FB9"
    static let loggingPeriod = "53B61C98-CACD-41FD-AF11-90CDD08F2A34"
    static let logMemCount0 = "D1FFC670-0BFC-4BC5-AFBC-0115A37F7DC7"
    static let logMemCount1 = "958D76C2-73DA-4D29-AE9A-97C91E9AA95C"
    
    static let dumTest1 = "9A681C49-919E-488E-9987-E821E91612B4"
    static let dumTest2 = "668BAA75-3E1C-4E75-8926-9F8A5E7C438C"
    static let dumTest3 = "E1BF8535-C930-4DD3-9AC6-8B53133E68A2"
    static let dumTest4 = "F089C654-2E28-4B2D-A7A6-4A43808AA1D1"
    static let dumTest5 = "59DE55B3-33F8-4DD4-9559-66C5BA1EAEAA"
    static let dumTest6 = "8CF9B0D9-D0BE-4FF8-994C-6961FD022B15"
    static let dumTest7 = "4A0AB681-855E-4F7A-A6EB-45E9354B33E3"
    static let dumTest8 = "ADB9655E-73F9-4F06-BB83-52098030E2D1"
    static let dumTest9 = "D7F2298C-C357-4E9F-8546-3F9F3EC3941D"
    static let dumTest10int8 = "90E45C3E-54B1-4087-9D40-59D2259315B2"
    
    //    These tests are UInt 16
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
  
}
