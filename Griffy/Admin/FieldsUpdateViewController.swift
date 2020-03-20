//
//  FieldsUpdateViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/18/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class FieldsUpdateViewController: BaseViewController {
  @IBOutlet weak var userIdField: UITextField!
  @IBOutlet weak var serialNumberField: UITextField!
  @IBOutlet weak var hardwareField: UITextField!
  @IBOutlet weak var displayFormatSegment: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupInitialValues()
    let tap = UITapGestureRecognizer(target: self, action: #selector(FieldsUpdateViewController.tapperTapped))
    view.addGestureRecognizer(tap)
  }
  
  @objc fileprivate func tapperTapped() {
    [userIdField, serialNumberField, hardwareField].forEach({ $0?.endEditing(true) })
  }
  
  fileprivate func setupInitialValues() {
    // Wheel properties
    if let hardChar = GFCharacteristic.hardwareVersion {
      hardwareField.text = hardChar.value?.griffyDisplayValue(characteristicId: hardChar.id)
    }
    if let serialChar = GFCharacteristic.serialNumber {
      serialNumberField.text = serialChar.value?.griffyDisplayValue(characteristicId: serialChar.id)
    }
    if let displayFormat = 
    
    // User default properties
    userIdField.text = GFUserDefaults.userIdMvp
    displayFormatSegment.selectedSegmentIndex = GFUserDefaults.displayFormatMvp == "A75" ? 0 : 1
  }
  
  override func keyboardWillHide(_ info: BaseViewController.KeyboardInfo) {
    UIView.animate(withDuration: 0.3) {
      self.view.transform = .identity
    }
  }
  
  @IBAction func segmentChanged(_ sender: Any) {
    GFUserDefaults.displayFormatMvp = displayFormatSegment.selectedSegmentIndex == 0 ? "A75" : "A85"
  }
  
  fileprivate func updateValues(fromTextField textField: UITextField) {
    switch textField {
    case userIdField:
      guard let val = textField.text else { return }
      GFUserDefaults.userIdMvp = val
    case serialNumberField:
      guard let serialChar = GFCharacteristic.serialNumber, let serial = textField.text, !serial.isEmpty else { return }
      let serialData = Data(bytes: Array(serial.utf8))
      BluetoothManager.shared.writeValue(data: serialData, toCharacteristic: serialChar)
    case hardwareField:
      guard let hardChar = GFCharacteristic.hardwareVersion, let hardware = textField.text, !hardware.isEmpty else { return }
      let hardwareData = Data(bytes: Array(hardware.utf8))
      BluetoothManager.shared.writeValue(data: hardwareData, toCharacteristic: hardChar)
    default:
      assertionFailure("Shouldn't really be here")
    }
  }
}

extension FieldsUpdateViewController: UITextFieldDelegate {
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    guard let info = currentKeyboardInfo else { return }
    let intersectionHeight = info.keyboardSize.intersection(textField.frame).size.height
    UIView.animate(withDuration: info.duration) {
      self.view.transform = CGAffineTransform(translationX: 0, y: -(intersectionHeight + 50))
      self.view.layoutIfNeeded()
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if string == "\n" {
      textField.endEditing(true)
      updateValues(fromTextField: textField)
    }
    var hasWhitespace = false
    string.forEach({
      if $0.isWhitespace {
        hasWhitespace = true
      }
    })
    
    return !hasWhitespace
  }
}
