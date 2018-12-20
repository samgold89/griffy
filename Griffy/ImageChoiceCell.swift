//
//  ImageChoiceCell.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/6/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class ImageChoiceCell: UICollectionViewCell {
  @IBOutlet weak var griffyImageView: UIImageView!
  @IBOutlet weak var sendRadialButton: UIButton!
  @IBOutlet weak var setActiveButton: UIButton!
  @IBOutlet weak var nameLabel: UILabel!
  
  var griffyImage: GriffyImage?
  
  func setupWithGriffy(griffy: GriffyImage) {
    griffyImage = griffy
    let image = UIImage(named: griffy.fileName)
    griffyImageView.image = image
    nameLabel.text = griffy.fileName
  }
  
  @IBAction func sendRadialButtonPressed(_ sender: Any) {
    guard let g = griffyImage else {
      assertionFailure("Missing griffy image when setting active.")
      return
    }
    
    self.sendRadialButton.setLoaderVisible(visible: true, style: UIActivityIndicatorView.Style.gray)
    BluetoothManager.shared.sendImageToDevice(withFileName: g.fileName) {
      self.sendRadialButton.setLoaderVisible(visible: false, style: UIActivityIndicatorView.Style.gray)
    }
  }
  
  @IBAction func setActiveButtonPressed(_ sender: Any) {
    guard let g = griffyImage else {
      assertionFailure("Missing griffy image when setting active.")
      return
    }
    setActiveButton.setLoaderVisible(visible: true, style: UIActivityIndicatorView.Style.gray)
    BluetoothManager.shared.setImageActive(index: g.index) {
      self.setActiveButton.setLoaderVisible(visible: false, style: nil)
    }
  }
}
