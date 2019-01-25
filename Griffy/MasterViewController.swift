//
//  MasterViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/17/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import CoreBluetooth

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  var characteristicsByServiceId = [String: [String: CBCharacteristic]]()
  var servicesById = [String: CBService]()
  
  let sections = ["Device","Status","Settings","Display","Battery"]
  let rows = [["serial number","hardware version","firmware version","led pitch"], ["imu1","imu2","alu1","alu2","status","wheel speed"], ["connect timeout"], ["image Load","image Select","image Erase","test","speed threshold","brightness"], ["temperature","instant current","average current","voltage","seconds remaining","percentage charge","mah remaining"]]


  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Touch a row to refresh it."
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(MasterViewController.updateAllValues))
  }
  
  @objc func updateAllValues() {
    BluetoothManager.shared.updateAllObservedValues()
  }

  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        
      }
    }
  }
  
  // MARK: - Table View
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let char = getCharacteristic(forIndexPath: indexPath) else {
      assertionFailure("Should have a characteristic when selecting.")
      return
    }
//    var value: Data!
//    if char.value == UInt8(3).data {
//      value = UInt8(4).data
//    } else {
//      value = UInt8(3).data
//    }
//    print("Writing new value: \(value)")
//    delay(0.2) {
//      let serviceId = Array(self.servicesById.keys)[indexPath.section]
//      let characteristic = Array(self.characteristicsByServiceId[serviceId]!.values)[indexPath.row]
//      self.griffyPeripheral?.readValue(for: characteristic)
//    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return servicesById.keys.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let serviceId = Array(servicesById.keys)[section]
    return characteristicsByServiceId[serviceId]?.count ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    configureCell(cell, withIndexPath: indexPath)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    let label = UILabel()
    
    view.backgroundColor = UIColor.lightGray
    
    label.textColor = UIColor.black
    label.translatesAutoresizingMaskIntoConstraints = false
    view.translatesAutoresizingMaskIntoConstraints = false
//    view.addSubview(label)
//    view.leadingAnchor.constraint(equalTo: tableView.layoutMarginsGuide.leadingAnchor).isActive = true
//    view.trailingAnchor.constraint(equalTo: tableView.layoutMarginsGuide.trailingAnchor).isActive = true
//    view.heightAnchor.constraint(equalToConstant: 5).isActive = true
    
    label.text = "YOUR TEAM"
    label.text = sections[section]
    label.backgroundColor = UIColor.clear
//    view.addSubview(label)
    
    return label
  }
  
  func configureCell(_ cell: UITableViewCell, withIndexPath indexPath: IndexPath) {
    guard let characteristic = getCharacteristic(forIndexPath: indexPath) else {
      showAlertWithTitle(title: "No Characteristic", body: "Missing characteristic for index path. \(indexPath)", buttonTitles: ["OK"])
      return
    }
    cell.textLabel!.text = characteristic.griffyName()
    cell.detailTextLabel?.text = characteristic.griffyDisplayValue()
  }
  
  func getCharacteristic(forIndexPath indexPath: IndexPath) -> CBCharacteristic? {
//    guard servicesById.keys.count < indexPath.section else {
//      showAlertWithTitle(title: "Missing Service", body: "Looking for section \(indexPath.section). Currently have these services: \(servicesById)", buttonTitles: ["OK"])
//      return nil
//    }
    let serviceId = Array(servicesById.keys)[indexPath.section]
    let characteristic = Array(characteristicsByServiceId[serviceId]!.values)[indexPath.row]
    return characteristic
  }
}

struct SerialNumber {
  var uuid: CBUUID?
  var name: String?
  var characteristic: CBCharacteristic?
  
  func value() -> String {
    return ""
  }
}

//SerialNumber
//HardwareVersion
//FirmwareVersion
//LEDPitch
//IMU1
//IMU2
//ALU1
//ALU2
//Status
//ConnectTimeout
//ImageLoad
//ImageSelect
//ImageErase
//Test
//SpeedThreshold
//Brightness
//Temperature
//InstantCurrent
//AverageCurrent
//Voltage
//SecondsRemaining
//PercentageCharge
//MAHRemaining
