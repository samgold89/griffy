//
//  BetaSetupVC.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import SSSpinnerButton // https://github.com/simformsolutions/SSSpinnerButton

class BetaSetupVC: UIViewController {
  @IBOutlet weak var spinnerButton: SSSpinnerButton!
  @IBOutlet weak var firstNameField: PaddedTextField!
  @IBOutlet weak var betaCodeField: PaddedTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapperTapped))
    view.addGestureRecognizer(tap)
  }
  
  @objc fileprivate func tapperTapped() {
    firstNameField.resignFirstResponder()
    betaCodeField.resignFirstResponder()
  }
  
  @IBAction func nextButtonPressed() {
    if validateTextFields() {
      spinnerButton.startAnimate(spinnerType: .ballRotateChase, spinnercolor: .white, spinnerSize: 30, complete: nil)
      guard let name = firstNameField.text, let code = betaCodeField.text else { return }
      createUser(name: name, code: code)
    }
  }
  
  fileprivate func validateTextFields() -> Bool {
    guard let text = firstNameField.text, text.count > 1 else {
      showAlertWithTitle(title: "Bad Name", body: "🛑 Please enter your full name and try again!", buttonTitles: ["OK"])
      return false
    }
    guard let betaCode = betaCodeField.text, betaCode.contains("89") else {
      showAlertWithTitle(title: "Invalide Code", body: "🛑 That code is not valid. Please double check and try again!", buttonTitles: ["OK"])
      return false
    }
    return true
  }
  
  fileprivate func createUser(name: String, code: String) {
    let _ = BetaUser.create(withName: name, betaCode: code)
    firstNameField.isEnabled = false
    betaCodeField.isEnabled = false
    delay(1.8) {
      self.spinnerButton.stopAnimatingWithCompletionType(completionType: .success) {
        self.present(UIStoryboard.betaVC(betaType: .instructions), animated: true, completion: nil)
      }
    }
  }
  
  @IBAction func seePolicyPressed(_ sender: Any) {
    
  }
}

extension BetaSetupVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == firstNameField {
      betaCodeField.becomeFirstResponder()
    } else {
      nextButtonPressed()
      betaCodeField.resignFirstResponder()
    }
    return true
  }
}
