//
//  DataExtensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/15/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation

extension Data {
  var wheelMemoryItem: AdMemoryMap.WheelMemoryItem? {
    let mem = try? PropertyListDecoder().decode(AdMemoryMap.WheelMemoryItem.self, from: self)
    assert(mem != nil)
    return mem
  }
}
