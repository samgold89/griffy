//
//  AdFileManager.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/12/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation

struct AdFileManager {
  let adFileDirectory = "ads"
  let hrResFolderName = "hiResRads"
  let stdResFolderName = "stdResRads"
  
  var ad: TestAd
  let fileManager = FileManager.default
  
  init(ad: TestAd) {
    self.ad = ad
    tryCreateFolders()
  }
  
  var shouldDownloadRadials: Bool {
    let stdDownloaded = try? fileManager.contentsOfDirectory(atPath: stdRadFolderUrl.relativePath)
    let hrDownloaded = try? fileManager.contentsOfDirectory(atPath: hrRadFolderUrl.relativePath)
    return stdDownloaded?.count != ad.stdRadUrls.count || hrDownloaded?.count != ad.hrRadUrls.count
  }
  
  func downloadAllRadials() {
    let f = FileNetworkManager()
    
    ad.stdRadUrls.forEach { (std) in
      guard let url = URL(string: std.url) else { return }
      let newPath = self.hrRadFolderUrl.appendingPathComponent("std-\(std.order + 100).rad") // + 100 for string sorting 1, 10, 2, 20, etc
      
      f.downloadFile(fromUrl: url, toUrl: newPath) { (comp) in
        if let error = comp.error {
          print("Failed to download hd file at URL: \(url)\nwith error: \(error)")
        }
//        try? print(self.fileManager.contentsOfDirectory(atPath: self.stdRadFolderUrl.relativePath))
      }
    }
    
    ad.hrRadUrls.forEach { (hr) in
      guard let url = URL(string: hr.url) else { return }
      let newPath = self.hrRadFolderUrl.appendingPathComponent("hr-\(hr.order + 100).rad") // + 100 for string sorting 1, 10, 2, 20, etc
      
      f.downloadFile(fromUrl: url, toUrl: newPath) { (comp) in
        if let error = comp.error {
          print("Failed to download hd file at URL: \(url)\nwith error: \(error)")
        }
//        try? print(self.fileManager.contentsOfDirectory(atPath: self.hrRadFolderUrl.relativePath))
      }
    }
  }
  
  var adFolderUrl: URL {
    let fileManager = FileManager.default
    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let destURL = directoryURL.appendingPathComponent(adFileDirectory).appendingPathComponent(ad.id)
    return destURL
  }
  
  var stdRadFolderUrl: URL {
    return adFolderUrl.appendingPathComponent(ad.baseKeyForFileStorage).appendingPathComponent(stdResFolderName, isDirectory: true)
  }
  
  var hrRadFolderUrl: URL {
    return adFolderUrl.appendingPathComponent(ad.baseKeyForFileStorage).appendingPathComponent(hrResFolderName, isDirectory: true)
  }
  
  private func tryCreateFolders() {
    do {
      try fileManager.createDirectory(atPath: stdRadFolderUrl.relativePath, withIntermediateDirectories: true, attributes: [:])
      try fileManager.createDirectory(atPath: hrRadFolderUrl.relativePath, withIntermediateDirectories: true, attributes: [:])
//      try fileManager.contentsOfDirectory(at: adFolderUrl, includingPropertiesForKeys: nil) // show all files, NOT directories
    } catch {
      print(error.localizedDescription)
    }
  }
  
//  private func tryCreateAdFolder() {
//    //Fails when the folder already exists
//    try? fileManager.createDirectory(at: adFolderUrl, withIntermediateDirectories: false, attributes: [:])
//  }
}
