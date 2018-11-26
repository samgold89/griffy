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

extension MasterViewController: CBPeripheralDelegate {
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
      if characteristicsByServiceId[service.uuid.uuidString] == nil {
        characteristicsByServiceId[service.uuid.uuidString] = [String: CBCharacteristic]()
      }
      characteristicsByServiceId[service.uuid.uuidString]?[characteristic.uuid.uuidString] = characteristic
      
      print("Discovered: \(characteristicNameById[characteristic.uuid.uuidString])")
      //      griffyPeripheral?.setNotifyValue(true, for: characteristic)
      printCharacteristicValue(characteristic)
    }
    tableView.reloadData()
  }
  
  func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
    if let e = error {
      print("ERROR writing value: \(e)")
      showAlertWithTitle(title: "Error", body: e.localizedDescription, buttonTitles: ["🤦‍♀️"])
    } else {
      let name = characteristicNameById[characteristic.uuid.uuidString] ?? "MISSING"
      //      showAlertWithTitle(title: "Success", body: "Wrote value to \(name).\nNew value is: \(getCharacteristicValue(characteristic)).\nLook right?", buttonTitles: ["Probably Not"])
      updateAllValues()
      //      characteristicsByServiceId[characteristic.service.uuid.uuidString]![characteristic.uuid.uuidString] = characteristic
      tableView.reloadData()
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    printCharacteristicValue(characteristic)
    characteristicsByServiceId[characteristic.service.uuid.uuidString]?[characteristic.uuid.uuidString] = characteristic
    tableView.reloadData()
  }
  
  private func getCharacteristicValue(_ characteristic: CBCharacteristic) -> UInt8! {
    guard let characteristicData = characteristic.value, let byte = characteristicData.first else {return nil}
    return byte
  }
  
  private func printCharacteristicValue(_ characteristic: CBCharacteristic) {
    guard let characteristicData = characteristic.value else {return}
    //    SerialNumber(
    //    print(characteristicNameById[characteristic.uuid.uuidString]!, characteristicData.count)
    let vals = characteristic.griffyValue()
    print(vals)
    print("\(characteristicNameById[characteristic.uuid.uuidString]!) = \(vals)")
  }
}
