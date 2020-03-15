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
  @IBOutlet weak var leftBrightnessLabel: UILabel!
  @IBOutlet weak var rightBrightnessLabel: UILabel!
  @IBOutlet weak var leftSlider: UISlider!
  @IBOutlet weak var rightSlider: UISlider!
  
  let brightnessMax = Float(15.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let build = "\(Bundle.main.infoDictionary!["CFBundleVersion"]!)"
    let version = "v. \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
    versionLabel.text = "\(version) (\(build))"
    
    let oldLeftBrightness = BLEStateManager.shared.leftBrightness
    leftSlider.value = Float(oldLeftBrightness)/brightnessMax
    
    let oldRightBrightness = BLEStateManager.shared.rightBrightness
    rightSlider.value = Float(oldRightBrightness)/brightnessMax
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    activeImage.image = BLEStateManager.shared.activeImage
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
    let leftOldBrightness = BLEStateManager.shared.leftBrightness
    let rightOldBrightness = BLEStateManager.shared.rightBrightness
    setBrightnessValue(newLeftBrightnessValue: leftOldBrightness, newRightBrightnessValue: rightOldBrightness, updateSlider: true)
  }
  
  @IBAction func onOffToggled(_ sender: Any) {
    guard let imageCharactersitic = GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.imageSelectId) else {
      return
    }
    
    if onOffSwitch.isOn {
      if let lastStored = GriffyImageState.lastSetImage {
        BluetoothManager.shared.setImageActive(griffy: lastStored.griffyImage, useHighRes: lastStored.setHighRes) { }
      }
    } else {
      BluetoothManager.shared.writeValue(data: UInt16(65535).data, toCharacteristic: imageCharactersitic)
    }
  }
  
  @IBAction func leftSliderSlid(_ sender: Any) {
    let newBrightnessValue = Int(leftSlider.value * brightnessMax)
    
    let currentValue = BLEStateManager.shared.leftBrightness
    
    print("CurrentL: \(Int(currentValue)), NewL: \(newBrightnessValue)")
    if Int(currentValue) == newBrightnessValue {
      return
    }
    
    setBrightnessValue(newLeftBrightnessValue: newBrightnessValue, newRightBrightnessValue: nil, updateSlider: false)
  }
  
  @IBAction func rightSliderSlid(_ sender: Any) {
    let newBrightnessValue = Int(rightSlider.value * brightnessMax)
    
    let currentValue = BLEStateManager.shared.rightBrightness
    
    print("CurrentR: \(Int(currentValue)), NewR: \(newBrightnessValue)")
    if Int(currentValue) == newBrightnessValue {
      return
    }
    
    setBrightnessValue(newLeftBrightnessValue: nil, newRightBrightnessValue: newBrightnessValue, updateSlider: false)
  }
  
  func setBrightnessValue(newLeftBrightnessValue: Int?, newRightBrightnessValue: Int?, updateSlider: Bool) {
    if newLeftBrightnessValue != BLEStateManager.shared.leftBrightness {
      guard let brightnessChar = GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.brightnessId) else {
        return
      }
      
      BluetoothManager.shared.writeValue(data: Data(bytes: [UInt8(newLeftBrightnessValue ?? BLEStateManager.shared.leftBrightness),UInt8(newRightBrightnessValue ?? BLEStateManager.shared.rightBrightness)]), toCharacteristic: brightnessChar)
      
      if let left = newLeftBrightnessValue {
        BLEStateManager.shared.leftBrightness = left
        leftBrightnessLabel.text = "L-Brightness = \(left)"
        if updateSlider {
          UIView.animate(withDuration: 0.3) { self.leftSlider.value = Float(left)/self.brightnessMax }
        }
      }
    }
    
    if newRightBrightnessValue != BLEStateManager.shared.rightBrightness {
      guard let brightnessChar = GFCharacteristic.find(GFCharacteristic.self, byId: CharacteristicIds.brightnessId) else {
        return
      }
      
      BluetoothManager.shared.writeValue(data: Data(bytes: [UInt8(newLeftBrightnessValue ?? BLEStateManager.shared.leftBrightness),UInt8(newRightBrightnessValue ?? BLEStateManager.shared.rightBrightness)]), toCharacteristic: brightnessChar)
      
      if let right = newRightBrightnessValue {
        BLEStateManager.shared.rightBrightness = right
        rightBrightnessLabel.text = "R-Brightness = \(right)"
        if updateSlider {
          UIView.animate(withDuration: 0.3) { self.rightSlider.value = Float(right)/self.brightnessMax }
        }
      }
    }
    
    print("Sending BT Update: L:\(BLEStateManager.shared.leftBrightness), R:\(BLEStateManager.shared.rightBrightness)")
  }
}
