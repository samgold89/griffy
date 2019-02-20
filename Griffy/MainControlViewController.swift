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
    NotificationCenter.default.addObserver(self, selector: #selector(MainControlViewController.bluetoothDidConnect), name: .bluetoothStateChanged, object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    setSliderToOldValue()
  }
  
  @objc func bluetoothDidConnect() {
    setSliderToOldValue()
  }
  
  func setSliderToOldValue() {
    let oldBrightness = GFStateManager.shared.brightness
    setBrightnessValue(newBrightnessValue: oldBrightness, updateSlider: true)
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
    
    let currentValue = GFStateManager.shared.brightness
    
    print("Current: \(Int(currentValue)), New: \(newBrightnessValue)")
    if Int(currentValue) == newBrightnessValue {
      return
    }
    
    setBrightnessValue(newBrightnessValue: newBrightnessValue)
  }
  
  func setBrightnessValue(newBrightnessValue: Int, updateSlider: Bool) {
    if newBrightnessValue != GFStateManager.shared.brightness {
      guard let brightnessChar = GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.brightnessId) else {
        return
      }
      
      BluetoothManager.shared.writeValue(data: Data(bytes: [UInt8(newBrightnessValue),UInt8(newBrightnessValue)]), toCharacteristic: brightnessChar)
      GFStateManager.shared.brightness = newBrightnessValue
    }
    
    brightnessLabel.text = "Brightness = \(newBrightnessValue)"
    
    if updateSlider {
      UIView.animate(withDuration: 0.3) {
        self.slider.value = Float(newBrightnessValue)/self.brightnessMax
      }
    }
  }
  
  func setBrightnessValue(newBrightnessValue: Int) {
    setBrightnessValue(newBrightnessValue: newBrightnessValue, updateSlider: false)
  }
}
