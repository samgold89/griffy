//
//  FileNetworkManager.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation

class FileNetworkManager {
  struct FileRadHandler {
    var error: String?
//    var localUrl: URL?
  }
  
  func downloadFile(fromUrl url: URL, toUrl: URL, completion: @escaping (FileRadHandler)->()) {
    let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
      do {
        if let localUrl = localURL {
          if FileManager.default.fileExists(atPath: toUrl.relativePath) {
            try FileManager.default.removeItem(atPath: toUrl.relativePath)
          }
          try FileManager.default.copyItem(atPath: localUrl.relativePath, toPath: toUrl.relativePath)// copyItem(at: localUrl, to: toUrl)
        }
      } catch {
        print("Failed to copy: \(error.localizedDescription)")
      }
      DispatchQueue.main.async {
        completion(FileRadHandler(error: error?.localizedDescription))
      }
    }
    
    task.resume()
  }
}
