//
//  BluetoothManager.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/17/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import CoreBluetooth

struct CharacterWriteResponse {
  var characteristic: CBCharacteristic
  var error: String?
}

struct GFYWriteRequest {
  var data: Data
  var characteristic: CBCharacteristic
}

final class BluetoothManager: NSObject {
  static let shared = BluetoothManager()
  var centralManager: CBCentralManager!
  var griffyPeripheral: CBPeripheral?
  var cbCharacteristicsById = [String: CBCharacteristic]()
  
  let minimumPacketSize = 27
  let griffyHeaderSize = 7
  
  var pendingWriteRequestCount = 0
  var pendingWriteRequests = [GFYWriteRequest]()
  
  var visibleCharacteristics: [GFCharacteristic]?
  
  var hasDiscoveredGriffy: Bool {
    get {
      return griffyPeripheral != nil
    }
  }
  
  fileprivate override init() {
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }
  
  func getAll() {
    //Placeholder just so the init() gets called
  }
  
  func startUpdateTimer() {
    Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (timer) in
      self.updateAllObservedValues()
    }
    updateAllObservedValues()
  }
  
  func updateAllObservedValues() {
    guard let visibleCharacteristics = visibleCharacteristics else {
      return
    }
    
    for characteristic in visibleCharacteristics {
      if let char = cbCharacteristicsById[characteristic.id] {
        griffyPeripheral?.readValue(for: char)
        print("reading \(characteristic.name)")
      }
    }
  }
  
  func setImageActive(index: Int, completion: @escaping ()->()) {
    guard let g = GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.imageSelectId) else {
      assertionFailure("Missing image active charactersitic.")
      completion()
      return
    }
    writeValue(data: Data(bytes: [UInt8(index)]), toCharacteristic: g)
    delay(2) {
      completion()
    }
  }
  
  func sendImageToDevice(radialFilePath: String, index: Int, completion: @escaping ()->()) {
    guard let data = FileManager.default.contents(atPath: radialFilePath) else {
      assertionFailure("Not radial data at path: \(radialFilePath)")
      completion()
      return
    }
    
    let maxLength = (griffyPeripheral?.maximumWriteValueLength(for: CBCharacteristicWriteType.withResponse) ?? minimumPacketSize) - griffyHeaderSize
    let imageDataArray = getDataChunks(data: data, length: maxLength)
    
    guard let char = GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.imageLoadId) else {
      completion()
      return
    }
    
    var idx = 0
    var offsetCounter = 0
    
    for el in imageDataArray {
      if let data = el.first {
        var prependedData = getOffsetData(imageId: index, offset: offsetCounter)
        prependedData.append(data)
        writeValue(data: prependedData, toCharacteristic: char)
        
        idx += 1
        offsetCounter += data.count
      } else {
        assertionFailure("Didn't find data in the first element...")
      }
    }
    delay(7) {
      completion()
    }
  }
  
  func getOffsetData(imageId: Int, offset: Int) -> Data {
    let remainder = offset % 65536
    let byteTwo = (offset - remainder)/65536
    let byteZero = remainder % 256
    let byteOne = (remainder - byteZero)/256
    let data = Data(bytes: [UInt8(imageId), UInt8(byteZero), UInt8(byteOne), UInt8(byteTwo)])
    return data
  }

  func getDataChunks(data: Data, length: Int) -> [[Data]] {
    var idx = 0
    var chunks = [[Data]]()
    while idx < data.count {
      let sub = [data.subdata(in: idx..<(min(idx+length, data.count)))]
      chunks.append(sub)
      idx += length
    }
    return chunks
  }
  
  func writeValue(data: Data, toCharacteristic characteristic: GFCharacteristic) {
    guard let char = cbCharacteristicsById[characteristic.uuid] else {
      assertionFailure("Couldn't find characteristic with that GFUUID: \(characteristic)")
      return
    }
    
    pendingWriteRequests.append(GFYWriteRequest(data: data, characteristic: char))
    checkSendPendingWriteRequests()
  }
  
  func checkSendPendingWriteRequests() {
//    if pendingWriteRequestCount < UserDefaults.standard.integer(forKey: UserDefaultConstants.maxOutgoingBLERequests) {
//      print("skipping the write request due to volume reasons")
//      return
//    } else if let pend = pendingWriteRequests.first {
//      print("SENDING a request from the queue")
//      pendingWriteRequestCount += 1
//      griffyPeripheral?.writeValue(pend.data, for: pend.characteristic, type: CBCharacteristicWriteType.withResponse)
//      pendingWriteRequests.remove(at: 0)
//    }
    while pendingWriteRequests.count > 0 {
      let pend = pendingWriteRequests.first!
      griffyPeripheral?.writeValue(pend.data, for: pend.characteristic, type: CBCharacteristicWriteType.withResponse)
      pendingWriteRequests.remove(at: 0)
    }
  }
  
  func cancelGriffyConnection() {
    if let griff = griffyPeripheral {
      centralManager.cancelPeripheralConnection(griff)
    }
  }
  
  func scanForPeripherals() {
    centralManager.scanForPeripherals(withServices: nil, options: nil)
  }
}

struct GFBluetoothState {
  let message: String
  let color: UIColor
}

extension BluetoothManager: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .unknown:
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Bluetooth state is unknown.", color: UIColor.gfYellow))
    case .resetting:
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Bluetooth state is resetting...", color: UIColor.gfYellow))
    case .unsupported:
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Central state is unsupported.", color: UIColor.gfRed))
    case .unauthorized:
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Bluetooth is not authorized", color: UIColor.gfRed))
    case .poweredOff:
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Bluetooth state is powered off.", color: UIColor.gfRed))
    case .poweredOn:
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Looking for Griffy...", color: UIColor.gfYellow))
      
//      centralManager.scanForPeripherals(withServices: [ServiceIds.batteryId.cbuuid(), ServiceIds.deviceId.cbuuid(), ServiceIds.displayId.cbuuid(), ServiceIds.settingsId.cbuuid(), ServiceIds.statusId.cbuuid()], options: nil)
      centralManager.scanForPeripherals(withServices: nil, options: nil)
//      let periphs = centralManager.retrievePeripherals(withIdentifiers: [UUID(uuidString: PeripheralIds.griffy) ?? UUID()])
//      if periphs.count != 1 {
////        assertionFailure("Should find at least one peripheral")
//        print("Should find at least one peripheral")
//      } else {
//        griffyPeripheral = periphs.first
//        centralManager.connect(griffyPeripheral!, options: nil)
//        griffyPeripheral?.delegate = self
//      }
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    if peripheral.name == "Griffy" {
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Did discover peripheral!", color: UIColor.gfYellow))
      griffyPeripheral = peripheral
      centralManager.connect(griffyPeripheral!, options: nil)
      griffyPeripheral?.delegate = self
    }
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Connected to Griffy!", color: UIColor.gfGreen))
    peripheral.discoverServices([ServiceIds.deviceId.cbuuid(), ServiceIds.statusId.cbuuid(), ServiceIds.settingsId.cbuuid(), ServiceIds.displayId.cbuuid(), ServiceIds.batteryId.cbuuid()])
    peripheral.delegate = self
  }
  
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Disconnected from Griffy 🤦‍♀️. Tap to scan again. Error: \(error?.localizedDescription ?? "~ no error description ~")", color: UIColor.gfRed))
  }
  
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Failed to connect to Griffy. Tap to retry. \(error?.localizedDescription ?? "~ no error description ~")", color: UIColor.gfRed))
  }
}

extension BluetoothManager: CBPeripheralDelegate {
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else { return }
    for service in services {
      peripheral.discoverCharacteristics(nil, for: service)
      peripheral.discoverCharacteristics([CharacteristicIds.imageLoadId.cbuuid()], for: service)
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    //    print(service.characteristics)
    guard let characteristics = service.characteristics else {
      return
    }
    
    for characteristic in characteristics {
      print("Discovered: \(characteristicNameById[characteristic.uuid.uuidString] ?? "nil-zip-nada")")
      printCharacteristicValue(characteristic)
      let _ = GFCharacteristic.parse(GFCharacteristic.self, characteristic: characteristic)
      cbCharacteristicsById[characteristic.uuid.uuidString] = characteristic
      
      if characteristic.uuid.uuidString == CharacteristicIds.imageLoadId {
        print("we out here")
      }
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
    pendingWriteRequestCount -= 1
    
    if let e = error {
      print("ERROR writing value: \(e)")
      assertionFailure("ERROR writing value: \(e)")
    } else {
      print("Wrote a value for \(characteristic.griffyCharacteristic()?.name ?? "NO NAME")")
      griffyPeripheral?.readValue(for: characteristic)
    }
    NotificationCenter.default.post(name: .didWriteToCharacteristic, object: CharacterWriteResponse(characteristic: characteristic, error: error?.localizedDescription))
    
    checkSendPendingWriteRequests()
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//    let char = GFCharacteristic.parse(GFCharacteristic.self, characteristic: characteristic)
    cbCharacteristicsById[characteristic.uuid.uuidString] = characteristic
    NotificationCenter.default.post(name: .didUpdateCharacteristic, object: characteristic)
//    if characteristic.uuid.uuidString == CharacteristicIds.instantCurrentId || characteristic.uuid.uuidString == CharacteristicIds.averageCurrentId {
//      print("we here \(characteristic.uuid.uuidString)")
//    }
  }
  
  private func printCharacteristicValue(_ characteristic: CBCharacteristic) {
//    guard let characteristicData = characteristic.value else {return}
    //    SerialNumber(
    //    print(characteristicNameById[characteristic.uuid.uuidString]!, characteristicData.count)
//    let vals = characteristic.griffyDisplayValue()
//    print(vals!)
//    print("\(characteristicNameById[characteristic.uuid.uuidString]!) = \(vals ?? nil)")
  }
}
