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

final class BluetoothManager: NSObject {
  static let shared = BluetoothManager()
  var centralManager: CBCentralManager!
  var griffyPeripheral: CBPeripheral?
  var characteristicsById = [String: CBCharacteristic]()
  
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
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (tiemr) in
      self.updateAllValues()
    }
  }
  
  func updateAllValues() {
    griffyPeripheral?.services?.forEach({ (service) in
      service.characteristics?.forEach({ (char) in
        griffyPeripheral?.readValue(for: char)
      })
    })
  }
  
  func writeValue(data: Data, toCharacteristic characteristic: GFCharacteristic) {
    guard let char = characteristicsById[characteristic.uuid] else {
      assertionFailure("Couldn't find characteristic with that GFUUID: \(characteristic)")
      return
    }
    griffyPeripheral?.writeValue(data, for: char, type: CBCharacteristicWriteType.withResponse)
  }
}

extension BluetoothManager: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .unknown:
      print("central.state is .unknown")
    case .resetting:
      print("central.state is .resetting")
    case .unsupported:
      print("central.state is .unsupported")
    case .unauthorized:
      print("central.state is .unauthorized")
    case .poweredOff:
      print("central.state is .poweredOff")
    case .poweredOn:
      print("central.state is .poweredOn")
      let periphs = centralManager.retrievePeripherals(withIdentifiers: [UUID(uuidString: PeripheralIds.griffy) ?? UUID()])
      if periphs.count != 1 {
        assertionFailure("Should find at least one peripheral")
      } else {
        griffyPeripheral = periphs.first
        centralManager.connect(griffyPeripheral!, options: nil)
        griffyPeripheral?.delegate = self
      }
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    peripheral.discoverServices([ServiceDeviceId.cbuuid(), ServiceStatusId.cbuuid(), ServiceSettingsId.cbuuid(), ServiceDisplayId.cbuuid(), ServiceBatteryId.cbuuid()])
    //    peripheral.discoverServices(nil)
    peripheral.delegate = self
  }
  
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
  }
}

extension BluetoothManager: CBPeripheralDelegate {
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else { return }
    for service in services {
      peripheral.discoverCharacteristics(nil, for: service)
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
      characteristicsById[characteristic.uuid.uuidString] = characteristic
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
    if let e = error {
      print("ERROR writing value: \(e)")
      assertionFailure("ERROR writing value: \(e)")
    } else {
//      print("CHECK TO SEE IF THE VALUE HERE IS THE NEW, UPDATED VALUE OR IF WE SHOULD REFETCH")
      griffyPeripheral?.readValue(for: characteristic)
      NotificationCenter.default.post(name: .didWriteToCharacteristic, object: characteristic)
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//    printCharacteristicValue(characteristic)
    let _ = GFCharacteristic.parse(GFCharacteristic.self, characteristic: characteristic)
    characteristicsById[characteristic.uuid.uuidString] = characteristic
    NotificationCenter.default.post(name: .didUpdateCharacteristic, object: characteristic)
  }
  
  private func printCharacteristicValue(_ characteristic: CBCharacteristic) {
    guard let characteristicData = characteristic.value else {return}
    //    SerialNumber(
    //    print(characteristicNameById[characteristic.uuid.uuidString]!, characteristicData.count)
    let vals = characteristic.griffyValue()
    print(vals!)
    print("\(characteristicNameById[characteristic.uuid.uuidString]!) = \(vals ?? nil)")
  }
}
