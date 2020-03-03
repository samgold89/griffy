//
//  GriffyImages.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/6/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation

struct GriffyImageState: Codable {
  let griffyImage: GriffyImage
  let setHighRes: Bool
  
  public static var lastSetImage: GriffyImageState? {
    if let data = UserDefaults.standard.value(forKey: UserDefaultConstants.lastGriffyImage) as? Data {
      return try? PropertyListDecoder().decode(GriffyImageState.self, from: data)
    }
    return nil
  }
  
  func saveInfo() {
    guard let data = try? PropertyListEncoder().encode(self) else {
      assertionFailure("Couldn't encode the branch info to UserDefaults")
      return
    }
    UserDefaults.standard.set(data, forKey: UserDefaultConstants.lastGriffyImage)
    UserDefaults.standard.synchronize()
  }
}

struct GriffyImage: Codable {
  let imageFilePath: String
  let stdRadialFilePaths: [String]?
  let hiResRadialFilePaths: [String]?
  let startingIndex: Int
  let frameDuration: Int
  
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

struct GriffyImageGetter {
  internal static func getAllImages(forClient client: String) -> [GriffyImage] {
    var images = [GriffyImage]()
    return images
  }
}
