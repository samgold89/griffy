//
//  ModelLocation.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/3/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class Location: Object {
  @objc dynamic var latitude: Double = 0.0
  @objc dynamic var longitude: Double = 0.0
  @objc dynamic var clientUuid: String!
  @objc dynamic var horizontalAccuracy: Double = 0.0
  @objc dynamic var speed: Double = 0.0
  @objc dynamic var course: Double = 0.0
  @objc dynamic var nickname: String!
  @objc dynamic var timestamp: Date!
  @objc dynamic var sentToServer: Bool = false
  
  @discardableResult
  public static func create(withLocation location: CLLocation) -> String {
    let realm = try! Realm()
    var clientUuid = ""
    try! realm.write {
      let l = realm.create(Location.self)
      l.latitude = location.coordinate.latitude
      l.longitude = location.coordinate.longitude
      l.horizontalAccuracy = location.horizontalAccuracy
      l.clientUuid = UUID().uuidString
      clientUuid = l.clientUuid
      l.speed = location.speed
      l.course = location.course
      l.nickname = BetaUser.me?.betaCode ?? "**MISSING**"
      l.timestamp = location.timestamp
    }
    return clientUuid
  }
  
  func markSent() {
    let realm = try! Realm()
    try! realm.write {
      realm.objects(Location.self).filter({ $0.clientUuid == self.clientUuid}).forEach({ $0.sentToServer = true })
    }
  }
  
  public static func find(byId id: String) -> Location? {
    let realm = try! Realm()
    return realm.objects(Location.self).filter(NSPredicate(format: "clientUuid = %@",id)).first
  }
  
  public static var lastLocation: Location? {
    let realm = try! Realm()
    return realm.objects(Location.self).sorted(byKeyPath: "timestamp", ascending: true).last
  }
  
  public static func lastLocationAfter(date: Date) -> Location? {
    let realm = try! Realm()
    return realm.objects(Location.self).filter(NSPredicate(format: "timestamp > %@", argumentArray: [date])).sorted(byKeyPath: "timestamp", ascending: true).last
  }
  
  public static var unsentLocations: [Location]? {
    let realm = try! Realm()
    return Array(realm.objects(Location.self).filter(NSPredicate(format: "sentToServer = false")).sorted(byKeyPath: "timestamp", ascending: true))
  }
}
