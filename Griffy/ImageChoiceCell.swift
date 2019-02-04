//
//  ImageChoiceCell.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/6/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

import CoreBluetooth

class ImageChoiceCell: UICollectionViewCell {
  @IBOutlet weak var griffyImageView: UIImageView!
  @IBOutlet weak var sendRadialButton: UIButton!
  @IBOutlet weak var setActiveButton: UIButton!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var indexLabel: UILabel!
  
  var griffyImage: GriffyImage?
  var hud: JGProgressHUD?
  var totalDataSent = 0
  var totalDataToSend = 0
  
  func setupWithGriffy(griffy: GriffyImage) {
    griffyImage = griffy
    let image = UIImage(contentsOfFile: griffy.imageFilePath)
    griffyImageView.image = image
    nameLabel.text = "Something"
    if let nameWithExtension = griffy.imageFilePath.split(separator: "/").last {
      nameLabel.text = "\(nameWithExtension.split(separator: ".").first ?? "Something")"
    }
    
    indexLabel.text = "Index = \(griffy.index)"
    NotificationCenter.default.addObserver(self, selector: #selector(imageLoadUpdated(note:)), name: .didWriteToCharacteristic, object: nil)
  }
  
  @IBAction func sendRadialButtonPressed(_ sender: Any) {
    guard let g = griffyImage else {
      assertionFailure("Missing griffy image when setting active.")
      return
    }
        
    hud = JGProgressHUD(style: .dark)
    hud!.textLabel.text = "Sending Data"
    hud!.interactionType = JGProgressHUDInteractionType.blockAllTouches
    hud!.show(in: UIApplication.shared.keyWindow!)
    
    totalDataSent = 0
    totalDataToSend = BluetoothManager.shared.sendImageToDevice(radialFilePath: g.radialFilePath, index: g.index)
  }
  
  @objc func imageLoadUpdated(note: Notification) {
    if let info = note.object as? CharacterWriteResponse {
      let dataSent = info.dataLength
      totalDataSent += dataSent
      hud?.detailTextLabel.text = "Sent \(totalDataSent) / \(totalDataToSend)"
      if totalDataSent >= totalDataToSend {
        hud?.dismiss(animated: true)
      }
    }
  }
  
  @IBAction func setActiveButtonPressed(_ sender: Any) {
    guard let g = griffyImage else {
      assertionFailure("Missing griffy image when setting active.")
      return
    }
    setActiveButton.setLoaderVisible(visible: true, style: UIActivityIndicatorView.Style.gray)
    
    BluetoothManager.shared.setImageActive(index: g.index) {
      UserDefaults.standard.set(g.index, forKey: UserDefaultConstants.lastSelectedImageIndex)
      UserDefaults.standard.set(g.index, forKey: UserDefaultConstants.lastSelectedImageIndex)
      self.setActiveButton.setLoaderVisible(visible: false, style: nil)
      
      GFStateManager.shared.activeImage = self.griffyImageView.image
      GFStateManager.shared.activeIndex = g.index
    }
  }
  
  override func prepareForReuse() {
    NotificationCenter.default.removeObserver(self)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
