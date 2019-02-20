//
//  StatusTableViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/25/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class StatusTableViewController: BaseTableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    observedIds = [CharacteristicIds.firmwareVersionId, CharacteristicIds.hardwareVersionId, CharacteristicIds.serialNumberId, CharacteristicIds.percentageChargeId, CharacteristicIds.secondsRemainingId, CharacteristicIds.mahRemainingId, CharacteristicIds.temperatureId, CharacteristicIds.instantCurrentId, CharacteristicIds.averageCurrentId, CharacteristicIds.voltageId, /*CharacteristicIds.imu1Id, CharacteristicIds.imu2Id, */CharacteristicIds.alu1Id, CharacteristicIds.alu2Id]
    
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    cell.isUserInteractionEnabled = false
    return cell
  }
}
