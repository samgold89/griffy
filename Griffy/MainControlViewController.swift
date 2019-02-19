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
  @IBOutlet weak var activeImage: UIImageView!
  @IBOutlet weak var versionLabel: UILabel!
  @IBOutlet weak var brightnessLabel: UILabel!
  @IBOutlet weak var slider: UISlider!
  
  let brightnessMax = Float(10.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let build = "\(Bundle.main.infoDictionary!["CFBundleVersion"]!)"
    let version = "v. \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
    versionLabel.text = "\(version) (\(build))"
    
    let oldBrightness = GFStateManager.shared.brightness
    slider.value = Float(oldBrightness)/brightnessMax
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    activeImage.image = GFStateManager.shared.activeImage
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let oldBrightness = GFStateManager.shared.brightness
    slider.value = Float(oldBrightness)/brightnessMax

    guard let brightnessChar = GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.brightnessId) else {
      return
    }
    
    BluetoothManager.shared.writeValue(data: Data(bytes: [UInt8(oldBrightness),UInt8(oldBrightness)]), toCharacteristic: brightnessChar)
  }
  
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
  
  @IBAction func sliderSlid(_ sender: Any) {
    let max = Float(10.0)
    
    let newBrightnessValue = Int(slider.value * max)
    guard let brightnessChar = GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.brightnessId) else {
      return
    }
    
    let currentValue = GFStateManager.shared.brightness
    
    print("Current: \(Int(currentValue)), New: \(newBrightnessValue)")
    if Int(currentValue) == newBrightnessValue {
      return
    }
    
    BluetoothManager.shared.writeValue(data: Data(bytes: [UInt8(newBrightnessValue),UInt8(newBrightnessValue)]), toCharacteristic: brightnessChar)
    brightnessLabel.text = "Brightness = \(newBrightnessValue)"
    GFStateManager.shared.brightness = newBrightnessValue
  }
}
