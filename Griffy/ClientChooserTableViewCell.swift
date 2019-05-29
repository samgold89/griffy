//
//  ClientChooserTableView.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/30/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDropbox

struct GriffyDropboxClient {
  let clientName: String
  let path: String
}

class ClientChooserTableViewCell: UITableViewCell {
  @IBOutlet weak var clientNameLabel: UILabel!
  @IBOutlet weak var fileCountLabel: UILabel!
  @IBOutlet weak var downloadButton: UIButton!
  var assetPaths = [String]()
  
  var imagePaths: [String]?
  var client: GriffyDropboxClient?
  
  func setupCellWithClient(_ client: GriffyDropboxClient) {
    self.client = client
    clientNameLabel.text = client.clientName
    
    setupImageUrls()
  }
  
  override func prepareForReuse() {
    fileCountLabel.text = "• • •"
    downloadButton.isEnabled = false
    fileCountLabel.textColor = UIColor.darkGray
    assetPaths.removeAll()
  }
  
  func setupImageUrls() {
    guard let dbxClient = DropboxClientsManager.authorizedClient, let client = client else {
      assertionFailure("Sholud have dropbox client in client chooser cell setup OR should have griffydropboxclient struct")
      return
    }
    
    assetPaths.removeAll()
    var radialCount = 0
    var imageCount = 0
    //List folder contents
    dbxClient.files.listFolder(path: client.path).response(completionHandler: { (result, error) in
      self.assetPaths.removeAll()
      if let entries = result?.entries {
        for res in entries {
          if let path = res.pathLower {
            self.assetPaths.append(path)
          }
          if res.name.lowercased().hasSuffix("radial") {
            radialCount += 1
          } else if res.name.hasImageSuffix() {
            imageCount += 1
          }
        }
      }
      self.fileCountLabel.text = "\(radialCount) radial files | \(imageCount) image files"
      self.downloadButton.isEnabled = true
    })
  }
  
  @IBAction func downloadButtonPressed(_ sender: Any) {
    downloadButton.setLoaderVisible(visible: true, style: .white, disabledTitle: "connecting to dropbox...")
    
    guard let clientName = client?.clientName else {
      assertionFailure("Missing client name. Can't download.")
      downloadButton.setLoaderVisible(visible: false, style: nil)
      return
    }
    
    if assetPaths.count == 0 {
      downloadButton.setLoaderVisible(visible: false, style: nil)
    }
    
    let fileManager = FileManager.default
    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let destURL = directoryURL.appendingPathComponent("clientAssets").appendingPathComponent(client?.clientName ?? "")
    
    GriffyFileManager.deleteClientFolderContents(name: clientName)
    GriffyFileManager.createClientFolder(name: clientName)
    
    guard let dbxClient = DropboxClientsManager.authorizedClient else {
      assertionFailure("Shouldn't be downloading if there's no authorized dropbox client")
      return
    }
    
    //Dropbox is doing something synchronous, blocking the loader from showing. This fixes that.
    delay(0.01) {
      var successCount = 0
      var errorCount = 0
      for path in self.assetPaths {
        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
          return destURL.appendingPathComponent(String(path.split(separator: "/").last ?? "somePath"))
        }
        
        dbxClient.files.download(path: path, overwrite: true, destination: destination)
          .response { response, error in
            if let e = error {
              print(e)
              self.fileCountLabel.textColor = UIColor.gfRed
              self.fileCountLabel.text = "Couldn't download \(path). \(e)"
              errorCount += 1
            } else {
              successCount += 1
              print("Downloaded: \(response?.0.name ?? "NAME MISSING")")
            }
            self.downloadButton.setTitleWithOutAnimation(title: "successes: (\(successCount))    –        failures: (\(errorCount))", for: .disabled)
            if successCount == self.assetPaths.count {
              // set active client
              UserDefaults.standard.set(self.client?.clientName, forKey: UserDefaultConstants.activeClientName)
              NotificationCenter.default.post(name: .activeClientChanged, object: nil)
              self.downloadButton.setLoaderVisible(visible: false, style: nil)
            } else if errorCount + successCount == self.assetPaths.count {
              // show error
              self.fileCountLabel.text = "Failed to download \(errorCount) files. Not setting active."
              self.downloadButton.setLoaderVisible(visible: false, style: nil)
            }
          }
          .progress { progressData in
        }
      }
    }
  }
}
