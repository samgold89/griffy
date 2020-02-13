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
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter
  }()
  
  static let cellDate: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yy"
    return dateFormatter
  }()
}
