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
  internal static func gifDataAtGriffyPath(path: String) -> UIImage? {
    let fileManager = FileManager.default
    if let data = fileManager.contents(atPath: path) {
      return UIImage.gif(data: data) ?? nil
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
  
  internal static func createClientFolder(name: String) {
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
    
    //xxx-000.radial, xxx-001.radial, xxx-002.radial
    let radialFiles = fullFileNames.filter { (str) -> Bool in return str.hasSuffix("radial") }.sorted()
    let imageFiles = fullFileNames.filter { (str) -> Bool in return str.hasImageSuffix() }.sorted()
    let durationFiles = fullFileNames.filter { (str) -> Bool in return str.hasSuffix("duration") }.sorted()
    
    var idx = 0
    for image in imageFiles {
      var radialArray = [String]()

      for radial in radialFiles {
//        let radSplit = "\(radial.split(separator: ".").first!)"
//        if radSplit == image.split(separator: ".").first ?? "" {
        if radial.contains(image.split(separator: ".").first ?? "") {
          //'private' prefix vs. not ...
          radialArray.append(destURL.appendingPathComponent(radial).path)
        }
      }
      let imagePath = destURL.appendingPathComponent(image).path
      
      let durationString = durationFiles.filter { (str) -> Bool in return str.contains(image.split(separator: ".").first ?? "")}.first?.split(separator: ".").first?.split(separator: "-").last ?? "0"
      let duration = Int(durationString) ?? 0
      
      images.append(GriffyImage(imageFilePath: imagePath, radialFilePaths: radialArray, index: idx, frameDuration: duration))
      idx += radialArray.count
    }
    
    return images
  }
}
