//
//  PeripheralTableViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/21/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class PeripheralTableViewController: UITableViewController {
  var peripherals = [CBPeripheral]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updatePeripherals()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return peripherals.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let periph = peripherals[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: PeripheralCell.reuseIdentifier) as! PeripheralCell
    cell.peripheralLabel.text = periph.name ?? "⛔️ MISSING NAME"
    
    if BluetoothManager.shared.peripheralName == periph.name, !(periph.name?.isEmpty ?? true) {
      cell.connectLabel.text = "✅ Connected"
    } else {
      cell.connectLabel.text = "⚠️ Connect"
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let periph = peripherals[indexPath.row]
    BluetoothManager.shared.connectToPeripheral(peripheral: periph)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  @IBAction func refreshPressed(_ sender: Any) {
    updatePeripherals()
  }
  
  fileprivate func updatePeripherals() {
    peripherals = BluetoothManager.shared.discoveredPeripherals.filter({$0.name != nil})
    tableView.reloadData()
  }
}

class PeripheralCell: UITableViewCell {
  static let reuseIdentifier = "PeripheralCell"
  @IBOutlet weak var peripheralLabel: UILabel!
  @IBOutlet weak var connectLabel: UILabel!
}
