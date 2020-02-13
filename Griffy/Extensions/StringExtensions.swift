//
//  StringExtensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/12/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation

extension String {
  private static let secondsInDay = 60*60*24
  private static let secondsInHour = 60*60
  private static let secondsInMinute = 60
  private static let millisecondsInSecond = 1000
  
  public static func hourMinSecFromSeconds(time: Int) -> String {
    let hours = String.hoursFromTotalTime(time: time, forceTwoDigits: true)
    let minutes = String.minutesFromTotalTime(time: time, forceTwoDigits: true)
    let seconds = String.secondsFromTotalTime(time: time, forceTwoDigits: true)
    return "\(hours):\(minutes):\(seconds)"
  }
  
  public static func hoursFromTotalTime(time: Int, forceTwoDigits: Bool) -> (String) {
    return forceTwoDigits ? String(format: "%02d", time/secondsInHour) : "\(time/secondsInHour)"
  }
  
  public static func minutesFromTotalTime(time: Int, forceTwoDigits: Bool) -> (String) {
    let minuteSecondsRemaining = time-(time/secondsInHour)*secondsInHour
    return forceTwoDigits ? String(format: "%02d", minuteSecondsRemaining/secondsInMinute) : "\(minuteSecondsRemaining/secondsInMinute)"
  }
  
  public static func secondsFromTotalTime(time: Int, forceTwoDigits: Bool) -> (String) {
    let minuteSecondsRemaining = time-(time/secondsInHour)*secondsInHour
    let secondSecondsRemaining = minuteSecondsRemaining-(minuteSecondsRemaining/secondsInMinute)*secondsInMinute
    return forceTwoDigits ? String(format: "%02d", secondSecondsRemaining) : "\(secondSecondsRemaining)"
  }
}
