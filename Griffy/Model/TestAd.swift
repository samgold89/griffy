//
//  TestAd.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import RealmSwift

class TestAd: BaseObject {
  @objc dynamic var ad_id: String!
  @objc dynamic var ad_type: String! // test vs. ¿live?
  @objc dynamic var active: Bool = true
  @objc dynamic var base_name: String!
  @objc dynamic var base_key: String!
  @objc dynamic var thumbnail_url: String!
  @objc dynamic var rad_frames: String!
  @objc dynamic var frame_duration: Double = 0.5  
}
