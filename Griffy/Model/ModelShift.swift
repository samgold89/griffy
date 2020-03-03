//
//  ModelShift.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/3/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift

class Shift: Object {
  @objc dynamic var startDate: Date!
  @objc dynamic var endDate: Date?
  
  var duration: Int {
    if let end = endDate {
      return Int(abs(end.timeIntervalSince(startDate)))
    } else {
      return Int(abs(Date().timeIntervalSince(startDate)))
    }
  }
  
  public static var currentShift: Shift? {
    let realm = try! Realm()
    let now = Date()
    return realm.objects(Shift.self).filter(NSPredicate(format: "startDate < %@ AND endDate = nil", argumentArray: [now])).first
  }
  
  
  /// Ends current shift with the time provided, or pulls from the last location recorded
  /// - Parameter usingTime: The time used to mark the end of the shift with. If nil, will use the last stored location
  public static func endCurrentShift(usingTime: Date?) {
    guard let currentShift = currentShift else { return }
    let realm = try! Realm()
    try! realm.write {
      currentShift.endDate = usingTime ?? Location.lastLocationAfter(date: currentShift.startDate)?.timestamp ?? Date()
    }
  }
  
  public static func beginNewShift() {
    assert(currentShift == nil)
    endCurrentShift(usingTime: nil) // failsafe
    
    let realm = try! Realm()
    try! realm.write {
      let s = realm.create(Shift.self)
      s.startDate = Date()
    }
  }
}
