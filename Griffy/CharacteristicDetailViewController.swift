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
  @IBOutlet weak var inputTextField: UITextField!
  @IBOutlet weak var currentValueLabel: UILabel!
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var lastUpdatedLabel: UILabel!
  
  override func viewDidLoad() {
    updateScreenValues()
    
    inputTextField.layer.borderColor = UIColor.darkGray.cgColor
    inputTextField.layer.borderWidth = CGFloat(1)
    inputTextField.placeholder = "If multiple values, separate with a comma"
    
    updateButton.isEnabled = false
    errorLabel.text = ""
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(CharacteristicDetailViewController.tapperTapped))
    view.addGestureRecognizer(tap)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(CharacteristicDetailViewController.characteristicWritten(notification:)), name: .didWriteToCharacteristic, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(CharacteristicDetailViewController.characteristicUpdated(notification:)), name: .didUpdateCharacteristic, object: nil)
  }
  
  func updateScreenValues() {
    let char = GFCharacteristic.find(GFCharacteristic.self, byId: characteristicId ?? "")
    if let val = char?.value?.griffyDisplayValue(characteristicId: characteristicId ?? "") {
      currentValueLabel.text = "Current Value\n\(val)"
    } else {
      currentValueLabel.text = "Current Value\n*no value*"
    }
    if let uAt = char?.updatedAt {
      lastUpdatedLabel.text = "Last Updated: \(uAt)"
    } else {
      lastUpdatedLabel.text = "Last Updated: –– –– ––"
    }
  }
  
  @objc func characteristicUpdated(notification: Notification) {
    if let note = notification.object as? CBCharacteristic {
      if note.uuid.uuidString == characteristicId {
        updateScreenValues()
      }
    }
  }
  
  @objc func characteristicWritten(notification: Notification) {
    updateButton.setLoaderVisible(visible: false, style: nil)
    
    inputTextField.text = nil
    inputTextField.layer.borderColor = UIColor.black.cgColor
    
    guard let note = notification.object as? CharacterWriteResponse else {
      assertionFailure("Uh oh - no char write response where expected")
      return
    }
    
    if note.characteristic.uuid.uuidString == characteristicId {
      updateScreenValues()
      if let e = note.error {
        self.errorLabel.textColor = UIColor.gfRed
        errorLabel.text = e
      } else {
        self.errorLabel.text = "✅ Value Updated"
        self.errorLabel.textColor = UIColor.gfGreen
      }
      delay(2) {
        self.errorLabel.text = ""
        self.errorLabel.textColor = UIColor.gfRed
      }
    }
  }
  
  @objc func tapperTapped() {
    view.endEditing(true)
  }
  
  @IBAction func updateValuePressed(_ sender: Any) {
    guard let char = GFCharacteristic.find(GFCharacteristic.self, byId: characteristicId ?? "") else {
      return
    }
    
    guard let text = inputTextField.text else {
      return
    }
    
    var arr = [UInt8]()
    for num in text.split(separator: ",") {
      if char.uuid == CharacteristicIds.speedThresholdId {
        arr.append(UInt8((Double(num) ?? 0)*100))
      } else if let uiNum = UInt8(num) {
        arr.append(uiNum)
      }
    }
    let data = Data(bytes: arr)
    BluetoothManager.shared.writeValue(data: data, toCharacteristic: char)
    updateButton.setLoaderVisible(visible: true, style: UIActivityIndicatorView.Style.whiteLarge)
  }
}

extension CharacteristicDetailViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if string == "\n" {
      textField.resignFirstResponder()
      return false
    }
    
    let newText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
    if let gfChar = GFCharacteristic.find(GFCharacteristic.self, byId: characteristicId ?? ""), let cbChar = BluetoothManager.shared.characteristicsById[gfChar.uuid] {
      
      let inputValid = cbChar.isValidInput(input: newText)
      if inputValid.success {
        updateButton.isEnabled = true
        errorLabel.text = ""
        textField.layer.borderColor = UIColor.gfGreen.cgColor
      } else {
        updateButton.isEnabled = false
        errorLabel.text = inputValid.error
        textField.layer.borderColor = UIColor.gfRed.cgColor
      }
    }
    if newText.count == 0 {
      textField.layer.borderColor = UIColor.black.cgColor
    }
    return true
  }
}
