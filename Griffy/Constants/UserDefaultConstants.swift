//
//  UserDefaultConstants.swift
//  Griffy
//
//  Created by Sam Goldstein on 1/27/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation

struct UserDefaultConstants {
  static let activeClientName = "activeClientName"
  static let maxOutgoingBLERequests = "maxOutgoingBLERequests"
  static let activeImageData = "activeImageData"
  static let activeIndex = "activeIndex"
  static let lastLeftBrightness = "lastLeftBrightness"
  static let lastRightBrightness = "lastRightBrightness"
  static let lastGriffyImage = "lastGriffyImage"
  static let lastPeripheralName = "lastPeripheralName"
  
  // Beta Variables
  static let betaUserId = "betaUserId"
  static let mvpUserId = "mvpUserId"
  static let mvpDisplayFormat = "mvpDisplayFormat"
  
  // User Variables
  static let userId = "userId"
}

class GFUserDefaults {
  public static var userIdMvp: String? {
    set {
      UserDefaults.standard.set(newValue, forKey: UserDefaultConstants.mvpUserId)
    }
    get {
      return UserDefaults.standard.string(forKey: UserDefaultConstants.mvpUserId)
    }
  }
  
  public static var displayFormatMvp: String? {
    set {
      UserDefaults.standard.set(newValue, forKey: UserDefaultConstants.mvpDisplayFormat)
    }
    get {
      return UserDefaults.standard.string(forKey: UserDefaultConstants.mvpDisplayFormat)
    }
  }
  
  public static var lastPeripheralName: String? {
    set {
      UserDefaults.standard.set(newValue, forKey: UserDefaultConstants.lastPeripheralName)
    }
    get {
      return UserDefaults.standard.string(forKey: UserDefaultConstants.lastPeripheralName)
    }
  }
}
