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
    
    observedIds = [CharacteristicIds.isReversedId, CharacteristicIds.speedThresholdId, CharacteristicIds.connectTimeoutId, CharacteristicIds.dumTest1, CharacteristicIds.dumTest2, CharacteristicIds.dumTest3, CharacteristicIds.dumTest4, CharacteristicIds.dumTest5, CharacteristicIds.dumTest6, CharacteristicIds.dumTest7, CharacteristicIds.dumTest8, CharacteristicIds.dumTest9, CharacteristicIds.dumTest10, CharacteristicIds.dumTest11, CharacteristicIds.dumTest12, CharacteristicIds.dumTest13, CharacteristicIds.dumTest14, CharacteristicIds.dumTest15, CharacteristicIds.dumTest16, CharacteristicIds.dumTest17, CharacteristicIds.animationId, CharacteristicIds.frameCountId, CharacteristicIds.frameDurationId, CharacteristicIds.lastFramePlayCount]
  }
}
