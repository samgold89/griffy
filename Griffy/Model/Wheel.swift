//
//  Wheel.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift

class Wheel: BaseObject {
  @objc dynamic var adMemoryMap: AdMemoryMap?
  public static var activeWheel: Wheel? {
    return nil
  }
}
