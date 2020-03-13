//
//  RadFrame.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/12/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift

class RadFrame: Object {
  @objc dynamic var url: String!
  @objc dynamic var order: Int = 0
  @objc dynamic var frame: Int = 0
}

class HrRadFrame: RadFrame {
  @objc dynamic var type: String = "hr"
}

class StdRadFrame: RadFrame {
  @objc dynamic var type: String = "std"
}
