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
  var totalDataSent = 0
  var totalDataToSend = 0
  var imagesForClient = [GriffyImage]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = UIColor.lightText
    view.backgroundColor = UIColor.lightText
    
    navigationItem.title = UserDefaults.standard.string(forKey: UserDefaultConstants.activeClientName)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(ImageChoiceCollectionViewController.clientDidChange), name: .activeClientChanged, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ImageChoiceCollectionViewController.imageLoadUpdated(note:)), name: .didWriteToCharacteristic, object: nil)
    clientDidChange()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func clientDidChange() {
    collectionView.reloadData()
    navigationItem.title = UserDefaults.standard.string(forKey: UserDefaultConstants.activeClientName)
    
    if let activeClient = UserDefaults.standard.string(forKey: UserDefaultConstants.activeClientName) {
      imagesForClient = GriffyFileManager.griffyImagesForClient(client: activeClient)
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.section == 1 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendAllImagesCell", for: indexPath) as! SendAllImagesCell
      cell.sendDelegate = self
      return cell
    }
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageChoiceCell", for: indexPath) as? ImageChoiceCell else {
      assertionFailure("ImageChoiceCell not found")
      return UICollectionViewCell()
    }
    
    if imagesForClient.count > indexPath.row {
      cell.setupWithGriffy(griffy: imagesForClient[indexPath.row])
    }
    
    return cell
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section > 0 {
      return 1
    }
    
    if let activeClient = UserDefaults.standard.string(forKey: UserDefaultConstants.activeClientName) {
      return GriffyFileManager.griffyImagesForClient(client: activeClient).count
    }
    return 0
  }
  
  @objc func imageLoadUpdated(note: Notification) {
    if let info = note.object as? CharacterWriteResponse {
      let dataSent = info.dataLength
      totalDataSent += dataSent
      
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = .decimal
      let totalSentString = numberFormatter.string(from: NSNumber(value: totalDataSent)) ?? ""
      let totalToSendString = numberFormatter.string(from: NSNumber(value: totalDataToSend)) ?? ""
      
      view.loadingView?.textLabel.text = "Sent \(totalSentString) / \(totalToSendString)"
      if totalDataSent >= totalDataToSend {
        view.hideLoadingView()
      }
    }
  }
}

extension ImageChoiceCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.section > 0 {
      return CGSize(width: (collectionView.bounds.width-20), height: CGFloat(50))
    }
    
    let yourWidth = (collectionView.bounds.width-20)/2.0
    let yourHeight = CGFloat(270)
    
    return CGSize(width: yourWidth, height: yourHeight)
  }
}

extension ImageChoiceCollectionViewController: SendAllImagesDelegate {
  func sendAllImages() {
    
    let total = GriffyFileManager.griffyImagesForClient(client: UserDefaults.standard.string(forKey: UserDefaultConstants.activeClientName) ?? "").count
    
    let alert = UIAlertController(title: "Starting At", message: "Which image number do you want to start at? 0-\(total)", preferredStyle: UIAlertController.Style.alert)
    alert.addTextField { (textField) in
      textField.keyboardType = .numberPad
    }
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Go!", style: .default, handler: { (action) in
      if let text = alert.textFields?.first?.text {
        self.sendAllImages(startingAt: Int(text) ?? 0)
      }
    }))
    present(alert, animated: true, completion: nil)
  }
  
  func sendAllImages(startingAt: Int) {
    totalDataToSend = 0
    totalDataSent = 0
    
    var idx = 0
    
    GriffyFileManager.griffyImagesForClient(client: UserDefaults.standard.string(forKey: UserDefaultConstants.activeClientName) ?? "").forEach { (image) in
      
      if idx >= startingAt {
        totalDataToSend += BluetoothManager.shared.sendGriffyImageToDevice(griffy: image, resetDataTotal: false)
      }
      idx += 1
    }
    view.showLoadingView(initialMessage: "Sending All Images")
  }
}

protocol SendAllImagesDelegate: class {
  func sendAllImages()
}

class SendAllImagesCell: UICollectionViewCell {
  @IBOutlet weak var sendAllButton: UIButton!
  weak var sendDelegate: SendAllImagesDelegate?
  
  @IBAction func sendAllImagesPressed(_ sender: Any) {
    NetworkManager.shared.sendLocations()
    return()
    sendDelegate?.sendAllImages()
  }
}

class MaxChunkLengthCell: UICollectionViewCell, UITextFieldDelegate {
  @IBOutlet weak var textField: UITextField!
  func setupCell() {
    textField.text = "\(UserDefaults.standard.integer(forKey: UserDefaultConstants.maxOutgoingBLERequests))"
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let int = Int(textField.text ?? "0") {
      if int != 0 {
        UserDefaults.standard.set(int, forKey: UserDefaultConstants.maxOutgoingBLERequests)
      }
    }
    textField.resignFirstResponder()
    return true
  }
}

