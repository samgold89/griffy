//
//  ModelBetaUser.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/3/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift

class BetaUser: Object {
  @objc dynamic var name: String!
  @objc dynamic var betaCode: String!
  @objc dynamic var id: String!
  
  var firstName: String {
    let first = name.split(separator: " ").first ?? "Firsty"
    return "\(first)"
  }
  
  public static var me: BetaUser? {
    let myId = UserDefaults.standard.string(forKey: UserDefaultConstants.betaUserId)
    let realm = try! Realm()
    return realm.objects(BetaUser.self).filter(NSPredicate(format: "id = %@",myId ?? "")).first
  }
  
  public static func create(withName name: String, betaCode: String) -> BetaUser {
    var myId = ""
    let realm = try! Realm()
    try! realm.write {
      let u = realm.create(BetaUser.self)
      u.id = UUID().uuidString
      myId = u.id
      u.name = name
      u.betaCode = betaCode
      UserDefaults.standard.set(u.id, forKey: UserDefaultConstants.betaUserId)
    }
    return realm.objects(BetaUser.self).filter(NSPredicate(format: "id = %@",myId)).first!
  }
}
