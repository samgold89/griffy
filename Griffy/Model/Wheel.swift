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
  @objc dynamic var serialNumber: String!
  @objc dynamic var currentStatus: String! // 'available', 'assigned', 'damaged'
  let userId = RealmOptional<Int>()
  let ownerId = RealmOptional<Int>()
  let shopId = RealmOptional<Int>()
  @objc dynamic var hardwareModel: String?
  @objc dynamic var hardwareRev: String?
  
  public static var activeWheel: Wheel? {
    let wheels = Wheel.findAll(Wheel.self)
      .filter({ $0.userId.value == User.me?.id })
      .sorted(by: { ($0.updatedAt ?? Date()).isBeforeDate($1.updatedAt ?? Date(), granularity: Calendar.Component.second) })
    
    return wheels.first
  }
}
