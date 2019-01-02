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
  let radialFilePath: String
  let index: Int
}

struct GriffyImageGetter {
  internal static func getAllImages(forClient client: String) -> [GriffyImage] {
    var images = [GriffyImage]()
//    images.append(GriffyImage(fileName: "cocacola", index: 0))
//    images.append(GriffyImage(fileName: "testfile4", index: 1))
//    images.append(GriffyImage(fileName: "starbucks", index: 2))
//    images.append(GriffyImage(fileName: "testfile2", index: 3))
//    images.append(GriffyImage(fileName: "sorry", index: 4))
//    images.append(GriffyImage(fileName: "testfile1", index: 5))
//    images.append(GriffyImage(fileName: "eli_bonaire", index: 6))
//    images.append(GriffyImage(fileName: "martin1", index: 7))
//    images.append(GriffyImage(fileName: "sam", index: 8))
//    images.append(GriffyImage(fileName: "letters2", index: 9))
//    images.append(GriffyImage(fileName: "letters1", index: 10))
//    images.append(GriffyImage(fileName: "letters3", index: 11))
    return images
  }
}
