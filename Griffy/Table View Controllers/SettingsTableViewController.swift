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

class SettingsTableViewController: BaseTableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    observedIds = [CharacteristicIds.isReversedId, CharacteristicIds.speedThresholdId, CharacteristicIds.connectTimeoutId, CharacteristicIds.dumTest1, CharacteristicIds.dumTest2, CharacteristicIds.dumTest3, CharacteristicIds.dumTest4, CharacteristicIds.dumTest5, CharacteristicIds.dumTest6, CharacteristicIds.lastFramePlayCount]
  }
}
