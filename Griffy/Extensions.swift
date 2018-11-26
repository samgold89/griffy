//
//  Extensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/17/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation

import UIKit

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
  func toHex() -> Int {
    if let val = Int("\(self)", radix: 16) {
      return val
    } else {
      assertionFailure("Failed to convert integer to hex. self=\(self)")
      return 0
    }
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
