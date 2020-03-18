//
//  User.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/17/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift

class User: BaseObject {
  @objc dynamic var name: String!
  @objc dynamic var email: String!
  @objc dynamic var phone: String?
  @objc dynamic var street: String?
  @objc dynamic var city: String?
  @objc dynamic var state: String?
  @objc dynamic var postalCode: String?
  @objc dynamic var country: String?
  @objc dynamic var profileImageUrl: String?
  @objc dynamic var profileThumbnailUrl: String?
  let secondsRidden = RealmOptional<Int>()
  let currentPumpId = RealmOptional<Int>()
  @objc dynamic var isEbikeUser: Bool = true
  @objc dynamic var paymentMethod: String?// ENUM ('PayPal', 'Venmo', 'CashApp')
  @objc dynamic var paymentId: String?

  var firstName: String {
    let first = name.split(separator: " ").first ?? "Firsty"
    return "\(first)"
  }
  
  public static var me: User? {
    let myId = UserDefaults.standard.integer(forKey: UserDefaultConstants.userId)
    
    guard myId > 0 else { return nil }
    
    let realm = try! Realm()
    return realm.objects(User.self).filter(NSPredicate(format: "id = %i",myId)).first
  }
}
