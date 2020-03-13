//
//  GriffyFileManager.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/30/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class GriffyFileManager {
  static let standardResolutionExtension = ".std"
  static let highResolutionExtension = ".hr"
  
  internal static func gifDataAtGriffyPath(path: String) -> UIImage? {
    let fileManager = FileManager.default
    if let data = fileManager.contents(atPath: path) {
      if let gif = UIImage.gif(data: data) {
        return gif
      } else {
        return UIImage(data: data) ?? nil
      }
    }
    return nil
  }
  
  internal static func deleteClientFolderContents(name: String) {
    let fileManager = FileManager.default
    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let destURL = directoryURL.appendingPathComponent("clientAssets").appendingPathComponent(name)
    
    do {
      let contents = try? fileManager.contentsOfDirectory(at: destURL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
      for path in contents ?? [URL]() {
//        let fullPath = destURL.appendingPathComponent(path.absoluteString)
        try fileManager.removeItem(at: path)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  internal static func createAdFolder(name: String) {
    let fileManager = FileManager.default
    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let assetUrl = directoryURL.appendingPathComponent("clientAssets")
    let destURL = assetUrl.appendingPathComponent(name)
    
    //Fails when the folder already exists
    try? fileManager.createDirectory(at: assetUrl, withIntermediateDirectories: false, attributes: [:])
    try? fileManager.createDirectory(at: destURL, withIntermediateDirectories: false, attributes: [:])
  }
  
  internal static func clientExists(client: String) -> Bool {
    let fileManager = FileManager.default
    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let destURL = directoryURL.appendingPathComponent("clientAssets").appendingPathComponent(client)
    
    return fileManager.fileExists(atPath: destURL.absoluteString)
  }
  
  internal static func griffyImagesForClient(client: String) -> [GriffyImage] {
    let fileManager = FileManager.default
    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let destURL = directoryURL.appendingPathComponent("clientAssets").appendingPathComponent(client)
    
    var images = [GriffyImage]()
    
    let folderContents = try? fileManager.contentsOfDirectory(at: destURL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
    guard folderContents != nil else {
      return images
    }
    
    //First we'll get all of the unique filenames
    let sortedFolderContents = folderContents!.sorted { (url1, url2) -> Bool in
      return url1.lastPathComponent.split(separator: ".").first ?? "0" < url2.lastPathComponent.split(separator: ".").first ?? "0"
    }
    var fullFileNames = Set<String>()
    
    var fileNames = Set<String>()
    for path in sortedFolderContents {
      fullFileNames.update(with: path.lastPathComponent)
      if let name = path.lastPathComponent.split(separator: ".").first {
        fileNames.update(with: "\(name)")
      } else {
        assertionFailure("Couldn't get the first part of the griffy filename.")
      }
    }
    
    let allHiResAndStandardRadialFiles = fullFileNames.filter { $0.hasSuffix("rad") }.sorted()
    let imageFiles = fullFileNames.filter { $0.hasImageSuffix() }.sorted()
    let durationFiles = fullFileNames.filter { $0.hasSuffix("dur") }.sorted()
    
    var idx = 0
    for image in imageFiles {
      guard let imagePrefix = image.split(separator: ".").first else { continue }
      let stdRadialArray = allHiResAndStandardRadialFiles
                            .filter({ $0.contains(imagePrefix) && $0.contains(GriffyFileManager.standardResolutionExtension) })
                            .compactMap({ destURL.appendingPathComponent($0).path })
      
      let hiResRadialArray = allHiResAndStandardRadialFiles
                              .filter({ $0.contains(imagePrefix) && $0.contains(GriffyFileManager.highResolutionExtension) })
                              .compactMap({ destURL.appendingPathComponent($0).path })
      
      let imagePath = destURL.appendingPathComponent(image).path
      
      var duration = 0
      if let splitDurationString = durationFiles.filter({ $0.contains(imagePrefix) }).first?.split(separator: ".").map({ "\($0)" }) {
        duration = Int(splitDurationString[splitDurationString.count - 2]) ?? duration
      }
      
      images.append(GriffyImage(imageFilePath: imagePath, stdRadialFilePaths: stdRadialArray.count > 0 ? stdRadialArray : nil, hiResRadialFilePaths: hiResRadialArray.count > 0 ? hiResRadialArray : nil, startingIndex: idx, frameDuration: duration))
      idx += (stdRadialArray.count + hiResRadialArray.count)
    }
    
    return images
  }
}
