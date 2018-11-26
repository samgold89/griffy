//
//  SettingsTableViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/25/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SettingsTableViewController: UITableViewController {
  var observedCharacteristics: Results<GFCharacteristic>?
  var token: NotificationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    token = observedCharacteristics?.GFObseveDataChanges(for: tableView, animateChanges: true)
  }
  
}
