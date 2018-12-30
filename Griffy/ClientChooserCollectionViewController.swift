//
//  ClientChooserCollectionViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/28/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDropbox

class ClientChooserCollectionViewController: UICollectionViewController {
  
  var clientFolders: Files.ListFolderResult?
  let dbxClientPath = "/Griffy App/clients_in_app"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = UIColor.lightText
    view.backgroundColor = UIColor.lightText
    
    if let cli = DropboxClientsManager.authorizedClient {
      cli.files.listFolder(path: dbxClientPath).response(completionHandler: { (result, error) in
        print(result)
        self.clientFolders = result
        self.viewClient(folderName: self.clientFolders?.entries.first?.name ?? "")
      })
//      downloadClient()
    } else {
      DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: {(url: URL) -> Void in
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      })
    }
  }
  
//  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageChoiceCell", for: indexPath) as? ImageChoiceCell else {
//      assertionFailure("ImageChoiceCell not found")
//      return UICollectionViewCell()
//    }
//    let griff = GriffyImageGetter.getAllImages()[indexPath.row]
//    cell.setupWithGriffy(griffy: griff)
//    return cell
//  }
  
  func viewClient(folderName: String) {
    guard let client = DropboxClientsManager.authorizedClient else {
      assertionFailure("Shouldn't be downloading if there's no authorized dropbox client")
      return
    }
    var assetPaths = [String]()
    var folderPath = "\(dbxClientPath)/\(folderName)"
    client.files.listFolder(path: folderPath).response(completionHandler: { (result, error) in
      if let entries = result?.entries {
        for res in entries {
          if let path = res.pathLower {
            assetPaths.append(path)
          } else {
            print("DIdn't have a lowered path when downloading...")
            assertionFailure("DIdn't have a lowered path when downloading...")
          }
        }
      }
      self.downloadFolderAssets(clientName: folderName, assetPaths: assetPaths)
    })
  }
  
  func downloadFolderAssets(clientName: String, assetPaths: [String]) {
    let fileManager = FileManager.default
    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let destURL = directoryURL.appendingPathComponent("clientAssets").appendingPathComponent(clientName)
    
    do {
      try fileManager.createDirectory(at: destURL, withIntermediateDirectories: false, attributes: [:])
    } catch {
      print(error.localizedDescription)
    }
    
    guard let client = DropboxClientsManager.authorizedClient else {
      assertionFailure("Shouldn't be downloading if there's no authorized dropbox client")
      return
    }
    
    var finishedCount = 0
    var errorCount = 0
    for path in assetPaths {
      let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
        return destURL.appendingPathComponent(String(path.split(separator: "/").last ?? "somePath"))
      }
      client.files.download(path: path, overwrite: true, destination: destination)
        .response { response, error in
          if let e = error {
            print(e)
            self.showAlertWithTitle(title: "Faild to Download", body: "Couldn't download \(path).\n\n\(e)", buttonTitles: ["So Now What?"])
            errorCount += 1
          } else {
            finishedCount += 1
            print("Downloaded: \(response?.0.name ?? "NAME MISSING")")
          }
          if finishedCount == assetPaths.count {
            // set active client
            UserDefaults.standard.set(clientName, forKey: UserDefaultConstants.activeClientName)
          } else if errorCount + finishedCount == assetPaths.count {
            // show error
            self.showAlertWithTitle(title: "Faild to download \(errorCount) files from the folder. Not setting the client active.", body: nil, buttonTitles: ["Great..."])
          }
        }
        .progress { progressData in
//          progressData.fractionCompleted
        }
    }
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
//    return GriffyImageGetter.getAllImages().count
  }
}

extension ClientChooserCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let yourWidth = (collectionView.bounds.width-20)/2.0
    let yourHeight = CGFloat(230)
    
    return CGSize(width: yourWidth, height: yourHeight)
  }
}
