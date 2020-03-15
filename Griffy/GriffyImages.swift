//
//  GriffyImages.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/6/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation

struct GriffyImage: Codable {
//  let adId: String
  let imageFilePath: String
  let stdRadialFilePaths: [String]?
  let hiResRadialFilePaths: [String]?
  let startingIndex: Int
  let frameDuration: Int
  
//  var ad: TestAd {
//    guard let ad = TestAd.find(TestAd.self, byId: adId) {
//      assertionFailure("Should have ad with id: \(adId)")
//      return TestAd()
//    }
//    return ad
//  }
  
  var frameCount: Int {
    if stdRadialFilePaths?.count ?? 0 > 0 {
      return stdRadialFilePaths?.count ?? 0
    } else {
      return (hiResRadialFilePaths?.count ?? 0) / 4
    }
  }
  
  init(imageFilePath: String, stdRadialFilePaths: [String]?, hiResRadialFilePaths: [String]?, startingIndex: Int, frameDuration: Int? = 0) {
    
    assert(stdRadialFilePaths != nil || hiResRadialFilePaths != nil)
    
    self.imageFilePath = imageFilePath
    self.stdRadialFilePaths = stdRadialFilePaths
    self.hiResRadialFilePaths = hiResRadialFilePaths
    self.startingIndex = startingIndex
    self.frameDuration = frameDuration ?? 0
  }
}
