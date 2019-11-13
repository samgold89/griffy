//
//  AdminMainTableViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/25/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftyDropbox

class AdminMainTableViewController: BaseTableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    observedIds = [CharacteristicIds.imageSelectId, CharacteristicIds.animationId, CharacteristicIds.frameCountId, CharacteristicIds.frameDurationId, CharacteristicIds.wheelSpeedId]
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row+1 == observedIds.count {
      //special case
      return UITableViewCell()
    } else {
      return super.tableView(tableView, cellForRowAt: indexPath)
    }
  }
//  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//  }
}
