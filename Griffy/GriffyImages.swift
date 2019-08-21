//
//  GriffyImages.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/6/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation

struct GriffyImage {
  let imageFilePath: String
  let radialFilePaths: [String]
  let index: Int
  let frameDuration: Int
  let isHighRes: Bool = false
  
  init(imageFilePath: String, radialFilePaths: [String], index: Int, frameDuration: Int? = 0, isHighRes: Bool) {
    self.imageFilePath = imageFilePath
    self.radialFilePaths = radialFilePaths
    self.index = index
    self.frameDuration = frameDuration ?? 0
    self.isHighRes = isHighRes
  }
}

struct GriffyImageGetter {
  internal static func getAllImages(forClient client: String) -> [GriffyImage] {
    var images = [GriffyImage]()
    return images
  }
}
