//
//  Wheel.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift

class Pump: BaseObject {
  @objc dynamic var peripheralName: String!
  @objc dynamic var currentStatus: String? // 'available', 'assigned', 'damaged'
  let userId = RealmOptional<Int>()
  let ownerId = RealmOptional<Int>()
  let shopId = RealmOptional<Int>()
  
  @objc dynamic var serialNumber: String? //TODO MVP: this should not be optional and should come from wheel
  @objc dynamic var hardwareModel: String? //TODO MVP: this should not be optional and should come from wheel
  @objc dynamic var hardwareRev: String? //TODO MVP: this should not be optional and should come from wheel
  @objc dynamic var displayFormat: String? //TODO MVP: this should not be optional and should come from wheel
  
  public static var activePump: Pump? {
    let pumps = Pump.findAll(Pump.self)
      .filter({ $0.peripheralName == BluetoothManager.shared.peripheralName })
    
    return pumps.first
  }
}
