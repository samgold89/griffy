//
//  ArrayExtensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

extension Float {
  var cgFloat: CGFloat {
    return CGFloat(self)
  }
  
  var double: Double {
    return Double(self)
  }
  
  var int: Int {
    return Int(self)
  }
}

extension CGFloat {
  var toRadians: CGFloat {
    return self*CGFloat.pi/180.0
  }
  
  var float: Float {
    return Float(self)
  }
  
  var double: Double {
    return Double(self)
  }
}

extension Double {
  var cgFloat: CGFloat {
    return CGFloat(self)
  }
  
  var float: Float {
    return Float(self)
  }
}

extension Int {
  var cgFloat: CGFloat {
    return CGFloat(self)
  }
  
  var float: Float {
    return Float(self)
  }
  
  var double: Double {
    return Double(self)
  }
}

