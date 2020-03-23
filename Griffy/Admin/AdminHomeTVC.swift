//
//  AdminHomeTVC.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/21/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class AdminHomeTVC: UITableViewController {
  override func viewDidLoad() {
    BluetoothManager.shared.scanForPeripherals()
  }
}
