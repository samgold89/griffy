//
//  Extensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/17/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

extension Int {
  var data: Data {
    var int = self
    return Data(bytes: &int, count: MemoryLayout<Int>.size)
  }
}

extension UInt8 {
  var data: Data {
    var int = self
    return Data(bytes: &int, count: MemoryLayout<UInt8>.size)
  }
}

extension UInt16 {
  var data: Data {
    var int = self
    return Data(bytes: &int, count: MemoryLayout<UInt16>.size)
  }
}

extension UInt32 {
  var data: Data {
    var int = self
    return Data(bytes: &int, count: MemoryLayout<UInt32>.size)
  }
  
  var byteArrayLittleEndian: [UInt8] {
    return [
      UInt8((self & 0xFF000000) >> 24),
      UInt8((self & 0x00FF0000) >> 16),
      UInt8((self & 0x0000FF00) >> 8),
      UInt8(self & 0x000000FF)
    ]
  }
}

import CoreBluetooth
extension String {
  func cbuuid() -> CBUUID {
    return CBUUID(string: self)
  }
}

/******* Probably garbage stuff
extension Data {
  init?(hexString: String) {
    let len = hexString.count / 2
    var data = Data(capacity: len)
    for i in 0..<len {
      let j = hexString.index(hexString.startIndex, offsetBy: i*2)
      let k = hexString.index(j, offsetBy: 2)
      let bytes = hexString[j..<k]
      if var num = UInt8(bytes, radix: 16) {
        data.append(&num, count: 1)
      } else {
        return nil
      }
    }
    self = data
  }
}
extension String {
  
  /// Create `Data` from hexadecimal string representation
  ///
  /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
  ///
  /// - returns: Data represented by this hexadecimal string.
  
  var hexadecimal: Data? {
    var data = Data(capacity: count / 2)
    
    let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
    regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
      let byteString = (self as NSString).substring(with: match!.range)
      let num = UInt8(byteString, radix: 16)!
      data.append(num)
    }
    
    guard data.count > 0 else { return nil }
    
    return data
  }
}

 ****/

extension UIViewController {
  func showAlertWithTitle(title: String?, body: String?, buttonTitles: [String]) {
    let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertController.Style.alert)
    for title in buttonTitles {
      alert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: nil))
    }
    self.present(alert, animated: false, completion: nil)
  }
}

extension Int {
  func toHex() -> String {
    return String(format:"%02X", self)
//    if let val = Int("\(self)", radix: 16) {
//      return val
//    } else {
//      assertionFailure("Failed to convert integer to hex. self=\(self)")
//      return 0
//    }
  }
  
  func toDecimal() -> Int {
    let decimal = String.init(self, radix: 16, uppercase: false)
    
    if let dec = Int(decimal) {
      return dec
    } else {
      assertionFailure("Failed to convert hex to decimal")
      return 0
    }
  }
  
  fileprivate static let secondsInDay = 60*60*24
  fileprivate static let secondsInHour = 60*60
  fileprivate static let secondsInMinute = 60
  
  func toTimeString() -> String {
    let hours = self.howManyHours(forceTwoDigits: true)
    let minutes = self.howManyMinutes(forceTwoDigits: true)
    let seconds = self.howManySeconds(forceTwoDigits: true)
    
    if self > 60*60 {
      return "\(hours):\(minutes):\(seconds)"
    } else {
      return "\(minutes):\(seconds)"
    }
  }
  
  func howManyDays(forceTwoDigits: Bool) -> (String) {
    return forceTwoDigits ? String(format: "%02d", self/Int.secondsInDay) : "\(self/Int.secondsInDay)"
  }
  
  func howManyHours(forceTwoDigits: Bool) -> (String) {
    return forceTwoDigits ? String(format: "%02d", self/Int.secondsInHour) : "\(self/Int.secondsInHour)"
  }
  
  func howManyMinutes(forceTwoDigits: Bool) -> (String) {
    let minuteSecondsRemaining = self-(self/Int.secondsInHour)*Int.secondsInHour
    return forceTwoDigits ? String(format: "%02d", minuteSecondsRemaining/Int.secondsInMinute) : "\(minuteSecondsRemaining/Int.secondsInMinute)"
  }
  
  func howManySeconds(forceTwoDigits: Bool) -> (String) {
    let minuteSecondsRemaining = self-(self/Int.secondsInHour)*Int.secondsInHour
    let secondSecondsRemaining = minuteSecondsRemaining-(minuteSecondsRemaining/Int.secondsInMinute)*Int.secondsInMinute
    return forceTwoDigits ? String(format: "%02d", secondSecondsRemaining) : "\(secondSecondsRemaining)"
  }
}

extension Data {
  init<T>(from value: T) {
    self = Swift.withUnsafeBytes(of: value) { Data($0) }
  }
  
  func to<T>(type: T.Type) -> T {
    return self.withUnsafeBytes { $0.pointee }
  }
  
  var uint8: UInt8 {
    get {
      var number: UInt8 = 0
      self.copyBytes(to:&number, count: MemoryLayout<UInt8>.size)
      return number
    }
  }
  
  var uint16: UInt16 {
    get {
      let i16array = self.withUnsafeBytes {
        UnsafeBufferPointer<UInt16>(start: $0, count: self.count/2).map(UInt16.init(littleEndian:))
      }
      return i16array[0]
    }
  }
  
  var uint32: UInt32 {
    get {
      let i32array = self.withUnsafeBytes {
        UnsafeBufferPointer<UInt32>(start: $0, count: self.count/2).map(UInt32.init(littleEndian:))
      }
      return i32array[0]
    }
  }
  
  var uuid: NSUUID? {
    get {
      var bytes = [UInt8](repeating: 0, count: self.count)
      self.copyBytes(to:&bytes, count: self.count * MemoryLayout<UInt32>.size)
      return NSUUID(uuidBytes: bytes)
    }
  }
  var stringASCII: String? {
    get {
      return NSString(data: self, encoding: String.Encoding.ascii.rawValue) as String?
    }
  }
  
  var stringUTF8: String? {
    get {
      return NSString(data: self, encoding: String.Encoding.utf8.rawValue) as String?
    }
  }
  
  struct HexEncodingOptions: OptionSet {
    let rawValue: Int
    static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
  }
  
  func hexEncodedString(options: HexEncodingOptions = []) -> String {
    let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
    return map { String(format: format, $0) }.joined()
  }
}

extension Array {
  var randomElement: Element {
    return self[Int(arc4random_uniform(UInt32(count)))]
  }
}

extension NSObject {
  func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
      execute: closure)
  }
}

extension UIColor {
  public static func hex(hex: String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
      cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
      return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  public static var gfGreen: UIColor {
    get {
      return UIColor.hex(hex: "06D6A0")
    }
  }
  
  public static var gfYellow: UIColor {
    get {
      return UIColor.hex(hex: "FFD166")
    }
  }
  
  public static var gfRed: UIColor {
    get {
      return UIColor.hex(hex: "EF476F")
    }
  }
  
  public static var gfBlue: UIColor {
    get {
      return UIColor.hex(hex: "26547C")
    }
  }
}

extension Notification.Name {
  static let didUpdateCharacteristic = Notification.Name("didUpdateCharacteristic")
  static let didWriteToCharacteristic = Notification.Name("didWriteToCharacteristic")
  static let bluetoothStateChanged = Notification.Name("bluetoothStateChanged")
  
  static let activeClientChanged = Notification.Name("activeClientChanged")
}

extension UIButton {
  func setLoaderVisible(visible: Bool, style: UIActivityIndicatorView.Style?) {
    /**********************************************
     If you're using the disabled state, handle it.
     currently it'll show an empty title label
     **********************************************/
    setTitle("", for: .disabled)

    let tagForLoader = 432253
    if visible {
      isEnabled = false
      if let _ = viewWithTag(tagForLoader) {
        var loader = viewWithTag(tagForLoader)
        loader!.removeFromSuperview()
        loader = nil
      }

      let loader = UIActivityIndicatorView(style: style ?? UIActivityIndicatorView.Style.whiteLarge)
      loader.startAnimating()
      loader.translatesAutoresizingMaskIntoConstraints = false
      loader.tag = tagForLoader
      addSubview(loader)
      loader.autoCenterInSuperview()

      imageView?.isHidden = true
      titleLabel?.isHidden = true
    } else {
      isEnabled = true
      if let loader = viewWithTag(tagForLoader) {
        loader.removeFromSuperview()
      } else {
        //        assertionFailure("Shouldn't be setting a non-existent loader invisible on a button")
      }
      imageView?.isHidden = false
      titleLabel?.isHidden = false
    }
  }

  func setBarLoading(isLoading: Bool, duration: Float) {
    let tagForBar = 381842

    if let view = viewWithTag(tagForBar) {
      view.removeFromSuperview()
    }

    if isLoading {
      let loaderView = UIView()
      loaderView.tag = tagForBar
      loaderView.layer.cornerRadius = layer.cornerRadius
      loaderView.layer.masksToBounds = layer.masksToBounds
      loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.07)
      loaderView.translatesAutoresizingMaskIntoConstraints = false
      addSubview(loaderView)
      loaderView.autoPinEdge(.left, to: .left, of: self)
      loaderView.autoPinEdge(.top, to: .top, of: self)
      loaderView.autoPinEdge(.bottom, to: .bottom, of: self)

      let rightConstraint = loaderView.autoPinEdge(.right, to: .right, of: self)
      rightConstraint.constant = -bounds.width
      layoutIfNeeded()

      UIView.animate(withDuration: TimeInterval(duration), animations: {
        rightConstraint.constant = 0
        self.layoutIfNeeded()
      }, completion: { (comp) in
        loaderView.removeFromSuperview()
      })
    }
  }
}
