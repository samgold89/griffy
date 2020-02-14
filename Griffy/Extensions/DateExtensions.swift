//
//  DateExtensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import SwiftDate

extension Date {
  
  var isMorning: Bool {
    let localDate = self.convertTo(region: Region.current)
    return localDate.hour <= 11
  }
  
  var isAfternoon: Bool {
    let localDate = self.convertTo(region: Region.current)
    return localDate.hour > 11 && localDate.hour < 17
  }
  
  var isEvening: Bool {
    let localDate = self.convertTo(region: Region.current)
    return localDate.hour >= 17
  }
  
  var timeOfDayDescriptor: String {
    if self.isMorning {
      return "Morning"
    } else if self.isAfternoon {
      return "Afternoon"
    } else if self.isEvening {
      return "Evening"
    } else {
      assertionFailure("Shouldn't be here")
      return "Day"
    }
  }
  
  func isSameDay(date: Date) -> Bool {
    let d1 = date.dateAtStartOf(.day)
    let d2 = self.dateAtStartOf(.day)
    let diff = Calendar.current.dateComponents([.day], from: d2, to: d1)
    if diff.day == 0 {
      return true
    } else {
      return false
    }
  }
}
