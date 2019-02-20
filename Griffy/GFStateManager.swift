//
//  GFStateManager.swift
//  Griffy
//
//  Created by Sam Goldstein on 1/25/19.
//  Copyright © 2019 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

final class GFStateManager: NSObject {
  static let shared = GFStateManager()
  
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
  
  var brightness: Int {
    set {
      UserDefaults.standard.set(newValue, forKey: UserDefaultConstants.lastBrightness)
    }
    get {
      return UserDefaults.standard.integer(forKey: UserDefaultConstants.lastBrightness)
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
