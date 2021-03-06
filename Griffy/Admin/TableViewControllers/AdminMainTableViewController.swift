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
    observedIds = [BLEConstants.CharacteristicIds.imageSelectId, BLEConstants.CharacteristicIds.wheelSpeedId, BLEConstants.CharacteristicIds.orientation]
  }
}
