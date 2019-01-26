//
//  MainControlViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 1/1/19.
//  Copyright © 2019 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class MainControlViewController: UIViewController {
  
  @IBOutlet weak var onOffSwitch: UISwitch!
  @IBOutlet weak var testSwitch: UISwitch!
  @IBOutlet weak var activeImage: UIImageView!
  
  @IBAction func onOffToggled(_ sender: Any) {
    guard let imageCharactersitic = GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.imageSelectId) else {
      return
    }
    
    let lastStored = UserDefaults.standard.integer(forKey: UserDefaultConstants.lastSelectedImageIndex) 
    if onOffSwitch.isOn {
      BluetoothManager.shared.writeValue(data: UInt8(lastStored).data, toCharacteristic: imageCharactersitic)
    } else {
      BluetoothManager.shared.writeValue(data: UInt8(255).data, toCharacteristic: imageCharactersitic)
    }
  }
  
  @IBAction func testToggled(_ sender: Any) {
    guard let testChar = GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.testId) else {
      return
    }
    
    if testSwitch.isOn {
      BluetoothManager.shared.writeValue(data: UInt8(1).data, toCharacteristic: testChar)
    } else {
      BluetoothManager.shared.writeValue(data: UInt8(0).data, toCharacteristic: testChar)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    activeImage.image = GFStateManager.shared.activeImage
  }
}
