//
//  RealmMigrations.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/25/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMigrations {
  //  https://realm.io/docs/swift/latest/#performing-a-migration
  
  func handle() {
    let config = Realm.Configuration(
      // Set the new schema version. This must be greater than the previously used
      // version (if you've never set a schema version before, the version is 0).
      schemaVersion: 9,
      migrationBlock: { migration, oldSchemaVersion in
        // Do Something
        if oldSchemaVersion < 8 {
          GFUserDefaults.displayFormatMvp = "A75"
        }
    })
    
    // Tell Realm to use this new configuration object for the default Realm
    Realm.Configuration.defaultConfiguration = config
  }
}
