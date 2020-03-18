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
    
    observedIds = [BLEConstants.CharacteristicIds.speedThresholdId, BLEConstants.CharacteristicIds.connectTimeoutId, BLEConstants.CharacteristicIds.dumTest1, BLEConstants.CharacteristicIds.dumTest2, BLEConstants.CharacteristicIds.dumTest3, BLEConstants.CharacteristicIds.dumTest4, BLEConstants.CharacteristicIds.dumTest5, BLEConstants.CharacteristicIds.dumTest6, BLEConstants.CharacteristicIds.dumTest7, BLEConstants.CharacteristicIds.dumTest8, BLEConstants.CharacteristicIds.dumTest9, BLEConstants.CharacteristicIds.dumTest10int8, BLEConstants.CharacteristicIds.dumTest10, BLEConstants.CharacteristicIds.dumTest11, BLEConstants.CharacteristicIds.dumTest12, BLEConstants.CharacteristicIds.dumTest13, BLEConstants.CharacteristicIds.dumTest14, BLEConstants.CharacteristicIds.dumTest15, BLEConstants.CharacteristicIds.dumTest16, BLEConstants.CharacteristicIds.dumTest17, BLEConstants.CharacteristicIds.isHighResolutionId, BLEConstants.CharacteristicIds.animationId, BLEConstants.CharacteristicIds.frameCountId, BLEConstants.CharacteristicIds.frameDurationId, BLEConstants.CharacteristicIds.lastFramePlayCount]
  }
}
