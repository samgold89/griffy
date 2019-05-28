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
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    NotificationCenter.default.addObserver(self, selector: #selector(imageLoadUpdated(note:)), name: .didWriteToCharacteristic, object: nil)
  }
  
  func setupWithGriffy(griffy: GriffyImage) {
    griffyImage = griffy
    DispatchQueue.global().async {
      let gif = GriffyFileManager.gifDataAtGriffyPath(path: griffy.imageFilePath)
//      let image = UIImage(contentsOfFile: griffy.imageFilePath)
      DispatchQueue.main.async {
        if self.griffyImage?.index == griffy.index {
          self.griffyImageView.image = gif
        }
      }
    }
    nameLabel.text = "Something"
    if let nameWithExtension = griffy.imageFilePath.split(separator: "/").last {
      nameLabel.text = "\(nameWithExtension.split(separator: ".").first ?? "Something")"
    }
    
    indexLabel.text = "Index = \(griffy.index)\(griffy.radialFilePaths.count > 1 ? " (\(griffy.radialFilePaths.count))" : "")"
  }
  
  @IBAction func sendRadialButtonPressed(_ sender: Any) {
    guard let g = griffyImage else {
      assertionFailure("Missing griffy image when setting active.")
      return
    }
    totalDataToSend = BluetoothManager.shared.sendGriffyImageToDevice(griffy: g)
    if totalDataToSend > 0 {
      showProgressIndicator(idx: g.index)
    } else {
      let text = sendRadialButton.titleLabel?.text
      sendRadialButton.setTitle("Failed to send...", for: .normal)
      delay(1) {
        self.sendRadialButton.setTitle(text, for: .normal)
      }
    }
  }
  
  func showProgressIndicator(idx: Int) {
    hud = JGProgressHUD(style: .dark)
    hud!.textLabel.text = "Sending Image: \(idx)"
    hud!.interactionType = JGProgressHUDInteractionType.blockNoTouches
    hud!.show(in: UIApplication.shared.keyWindow!)
    
    totalDataSent = 0
  }
  
  @objc func imageLoadUpdated(note: Notification) {
    if let info = note.object as? CharacterWriteResponse {
      let dataSent = info.dataLength
      totalDataSent += dataSent
      
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = .decimal
      let totalSentString = numberFormatter.string(from: NSNumber(value: totalDataSent)) ?? ""
      let totalToSendString = numberFormatter.string(from: NSNumber(value: totalDataToSend)) ?? ""
      
      hud?.detailTextLabel.text = "Sent \(totalSentString) / \(totalToSendString)"
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
    
    BluetoothManager.shared.setImageActive(griffy: g) {
      UserDefaults.standard.set(g.index, forKey: UserDefaultConstants.lastSelectedImageIndex)
      UserDefaults.standard.set(g.index, forKey: UserDefaultConstants.lastSelectedImageIndex)
      self.setActiveButton.setLoaderVisible(visible: false, style: nil)
      
      GFStateManager.shared.activeImage = self.griffyImageView.image
      GFStateManager.shared.activeIndex = g.index
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
