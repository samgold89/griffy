//
//  CharacteristicDetailViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/26/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift
import CoreBluetooth

class CharacteristicDetailViewController: UIViewController {
  var characteristicId: String?
  var observedCharacteristic: Results<GFCharacteristic>?
  var token: NotificationToken?
  @IBOutlet weak var updateButton: UIButton!
  @IBOutlet weak var currentValueLabel: UILabel!
  
  override func viewDidLoad() {
    updateScreenValues()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(CharacteristicDetailViewController.tapperTapped))
    view.addGestureRecognizer(tap)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(CharacteristicDetailViewController.characteristicWritten(notification:)), name: .didWriteToCharacteristic, object: nil)
  }
  
  func updateScreenValues() {
    let char = GFCharacteristic.find(GFCharacteristic.self, byId: characteristicId ?? "")
    if let val = char?.value?.griffyValue(characteristicId: characteristicId ?? "") {
      currentValueLabel.text = "Current Value\n\(val)"
    } else {
      currentValueLabel.text = "Current Value\n*no value*"
    }
  }
  
  @objc func characteristicWritten(notification: Notification) {
    updateButton.isEnabled = true
    updateButton.alpha = 1
    if let note = notification.object as? CBCharacteristic {//, let gfChar = GFCharacteristic.find(GFCharacteristic.self, byId: note.uuid.uuidString) {
      if note.uuid.uuidString == characteristicId {
        updateScreenValues()
      }
    }
  }
  
  @objc func tapperTapped() {
    view.endEditing(true)
  }
  
  @IBAction func updateValuePressed(_ sender: Any) {
    var value: Data!
    guard let char = GFCharacteristic.find(GFCharacteristic.self, byId: characteristicId ?? "") else {
      return
    }
    if char.value == UInt8(3).data {
      value = UInt8(4).data
    } else {
      value = UInt8(3).data
    }
    BluetoothManager.shared.writeValue(data: value, toCharacteristic: char)
    updateButton.isEnabled = false
    updateButton.alpha = 0.3
  }
}
