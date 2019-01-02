//
//  ImageChoiceCollectionViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/6/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class ImageChoiceCollectionViewController: UICollectionViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = UIColor.lightText
    view.backgroundColor = UIColor.lightText
    
    navigationItem.title = UserDefaults.standard.string(forKey: UserDefaultConstants.activeClientName)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(ImageChoiceCollectionViewController.clientDidChange), name: .activeClientChanged, object: nil)
    clientDidChange()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func clientDidChange() {
    collectionView.reloadData()
    navigationItem.title = UserDefaults.standard.string(forKey: UserDefaultConstants.activeClientName)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.section == 1 {
      return collectionView.dequeueReusableCell(withReuseIdentifier: "SendAllImagesCell", for: indexPath)
    }
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageChoiceCell", for: indexPath) as? ImageChoiceCell else {
      assertionFailure("ImageChoiceCell not found")
      return UICollectionViewCell()
    }
    
    if let activeClient = UserDefaults.standard.string(forKey: UserDefaultConstants.activeClientName) {
      cell.setupWithGriffy(griffy: GriffyFileManager.griffyImagesForClient(client: activeClient)[indexPath.row])
    }
    return cell
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 1 {
      return 1
    }
    
    if let activeClient = UserDefaults.standard.string(forKey: UserDefaultConstants.activeClientName) {
      return GriffyFileManager.griffyImagesForClient(client: activeClient).count
    }
    return 0
  }
}

extension ImageChoiceCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.section == 1 {
      return CGSize(width: (collectionView.bounds.width-20), height: CGFloat(50))
    }
    
    let yourWidth = (collectionView.bounds.width-20)/2.0
    let yourHeight = CGFloat(230)
    
    return CGSize(width: yourWidth, height: yourHeight)
  }
}

class SendAllImagesCell: UICollectionViewCell {
  @IBAction func sendAllImagesPressed(_ sender: Any) {
    if let sender = sender as? UIButton {
      sender.setLoaderVisible(visible: true, style: .white)
      delay(30) {
        sender.setLoaderVisible(visible: false, style: nil)
      }
      
      GriffyFileManager.griffyImagesForClient(client: UserDefaults.standard.string(forKey: UserDefaultConstants.activeClientName) ?? "").forEach { (image) in
        BluetoothManager.shared.sendImageToDevice(radialFilePath: image.radialFilePath, index: image.index, completion: {
          print("completed one?")
        })
      }
    }
  }
}
