//
//  BaseViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/12/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
  struct KeyboardInfo {
      let keyboardSize: CGRect
      let duration: TimeInterval
    let options: UIView.AnimationOptions
  }
  
  var currentKeyboardInfo: KeyboardInfo?
  
  // MARK: - Notification selector
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(selectorKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(selectorKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc fileprivate func selectorKeyboardWillShow(notification: Notification) {
    guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
      let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
      let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
        return
    }
    let keyboardInfo = KeyboardInfo(keyboardSize: keyboardSize, duration: duration, options: UIView.AnimationOptions(rawValue: curve))
    currentKeyboardInfo = keyboardInfo
    keyboardWillShow(keyboardInfo)
  }
  
  @objc fileprivate func selectorKeyboardWillHide(notification: Notification) {
    guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
      let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
      let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
        return
    }
    let keyboradInfo = KeyboardInfo(keyboardSize: keyboardSize, duration: duration, options: UIView.AnimationOptions(rawValue: curve))
    currentKeyboardInfo = nil
    keyboardWillHide(keyboradInfo)
  }
  
  // MARK: - Keyboard action
  
  func keyboardWillShow(_ info: KeyboardInfo) {
      
  }
  
  func keyboardWillHide(_ info: KeyboardInfo) {
      
  }
}
