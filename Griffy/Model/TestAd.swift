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
  // 700 image slots
  @objc dynamic var type: String! // test vs. ¿live?
  @objc dynamic var active: Bool = true
  @objc dynamic var baseName: String!
  @objc dynamic var baseKey: String!
  @objc dynamic var thumbnailUrl: String!
  @objc dynamic var frameDuration: Double = 0.5
  
  let hrRadUrls = List<HrRadFrame>()
  let stdRadUrls = List<StdRadFrame>()
  
  var baseKeyForFileStorage: String {
    return baseKey.replacingOccurrences(of: "/", with: "-")
  }
  
  var hrRadFilePaths: [String]? {
    return [""]
  }
  
  var stdRadFilePaths: [String] {
    return [""]
  }
  
  var shouldDownloadRadials: Bool {
    let ad = AdFileManager(ad: self)
    return ad.shouldDownloadRadials
  }
  
  func downloadRadials() {
    let ad = AdFileManager(ad: self)
    ad.downloadAllRadials()
  }
}
