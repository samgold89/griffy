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
    return localDate.hour > 11 && hour < 5
  }
  
  var isEvening: Bool {
    let localDate = self.convertTo(region: Region.current)
    return localDate.hour >= 5
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
}
