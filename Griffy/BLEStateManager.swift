//
//  BLEStateManager.swift
//  Griffy
//
//  Created by Sam Goldstein on 1/25/19.
//  Copyright © 2019 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

final class BLEStateManager: NSObject {
  static let shared = BLEStateManager()
  
  var activeImage: UIImage? {
    didSet {
      guard let activeImage = activeImage else {
        return
      }
      UserDefaults.standard.setValue(image: activeImage, forKey: UserDefaultConstants.activeImageData)
    }
  }
  var activeIndex: Int = 0 {
    didSet {
      UserDefaults.standard.set(activeIndex, forKey: UserDefaultConstants.activeIndex)
    }
  }
  
  var leftBrightness: Int {
    set {
      UserDefaults.standard.set(newValue, forKey: UserDefaultConstants.lastLeftBrightness)
    }
    get {
      return UserDefaults.standard.integer(forKey: UserDefaultConstants.lastLeftBrightness)
    }
  }
  
  var rightBrightness: Int {
    set {
      UserDefaults.standard.set(newValue, forKey: UserDefaultConstants.lastRightBrightness)
    }
    get {
      return UserDefaults.standard.integer(forKey: UserDefaultConstants.lastRightBrightness)
    }
  }
  
  fileprivate override init() {
    super.init()
    loadPreviousValues()
  }
  
  func loadPreviousValues() {
    if let data = UserDefaults.standard.data(forKey: UserDefaultConstants.activeImageData) {
      if let image = UIImage(data: data) {
        activeImage = image
      }
    }
    activeIndex = UserDefaults.standard.integer(forKey: UserDefaultConstants.activeIndex)
  }
}

struct GriffyImageState: Codable {
  let griffyImage: GriffyImage
  let setHighRes: Bool
  
  public static var lastSetImage: GriffyImageState? {
    if let data = UserDefaults.standard.value(forKey: UserDefaultConstants.lastGriffyImage) as? Data {
      return try? PropertyListDecoder().decode(GriffyImageState.self, from: data)
    }
    return nil
  }
  
  func saveInfo() {
    guard let data = try? PropertyListEncoder().encode(self) else {
      assertionFailure("Couldn't encode the branch info to UserDefaults")
      return
    }
    UserDefaults.standard.set(data, forKey: UserDefaultConstants.lastGriffyImage)
    UserDefaults.standard.synchronize()
  }
}
