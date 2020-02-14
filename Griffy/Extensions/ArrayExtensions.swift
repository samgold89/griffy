//
//  ArrayExtensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation

extension Array {
  var randomElement: Element {
    return self[Int(arc4random_uniform(UInt32(count)))]
  }
}
