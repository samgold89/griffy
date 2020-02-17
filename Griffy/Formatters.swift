//
//  Formatters.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation

struct Formatters {
  static let locationDate: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    // ensures for beta we use locatl time, since we already released with that.
    // for production, we'll format correctly
    if APIConstants.apiUrl != "https://8gr68l5g90.execute-api.us-east-1.amazonaws.com/poc" {
      dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    }
    
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter
  }()
  
  static let cellDate: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yy"
    return dateFormatter
  }()
}
