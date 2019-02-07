//
//  GriffyFileManager.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/30/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation

class GriffyFileManager {
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
    var fileNames = Set<String>()
    for path in sortedFolderContents {
      if let name = path.lastPathComponent.split(separator: ".").first {
        fileNames.update(with: "\(name)")
      } else {
        assertionFailure("Couldn't get the first part of the griffy filename.")
      }
    }
    
    //Now we'll grab the radial and image pairs
    var idx = 0
    let sortedFileNames = fileNames.sorted(by: >)
    for fileName in sortedFileNames {
      //Get the two file we want (radial & image)
      let files = sortedFolderContents.filter({ (url) -> Bool in
        return "\(url.lastPathComponent.split(separator: ".").first ?? "")" == fileName
      })
      
      if files.count == 2 {
        if files.first!.lastPathComponent.hasSuffix("radial") {
          images.append(GriffyImage(imageFilePath: files.last!.path, radialFilePath: files.first!.path, index: idx))
        } else {
          images.append(GriffyImage(imageFilePath: files.first!.path, radialFilePath: files.last!.path, index: idx))
        }
      } else {
//          assertionFailure("Didn't find the two files we needed with name \(fileName)")
      }
      
      idx += 1
    }
    
    return images
  }
}
