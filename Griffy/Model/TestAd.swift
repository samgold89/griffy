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
  @discardableResult
  override class func parse<T: Object>(_ type: T.Type, dictionary: [String: Any?], update: Bool = true) -> T? {
    let newT = super.parse(type, dictionary: dictionary, update: update)
    guard let ta = newT as? TestAd else { return newT }
    if ta.shouldDownloadRadials {
      ta.downloadRadials()
    }
    return newT
  }
  
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
    let ad = AdFileManager(ad: self)
    do {
      let paths = try FileManager.default.contentsOfDirectory(atPath: ad.hrRadFolderUrl.relativePath).map({ ad.hrRadFolderUrl.appendingPathComponent($0).relativePath })
      return paths
    } catch {
      return nil
    }
  }
  
  var stdRadFilePaths: [String]? {
    let ad = AdFileManager(ad: self)
    do {
      let paths = try FileManager.default.contentsOfDirectory(atPath: ad.stdRadFolderUrl.relativePath).map({ ad.stdRadFolderUrl.appendingPathComponent($0).relativePath })
      return paths
    } catch {
      return nil
    }
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
