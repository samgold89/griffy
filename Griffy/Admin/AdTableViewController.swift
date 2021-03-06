//
//  AdCollectionViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/16/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SDWebImage

class AdTableViewController: UITableViewController {
  var ads: Results<TestAd>!
  
  override func viewDidLoad() {
    let realm = try! Realm()
    ads = realm.objects(TestAd.self).sorted(byKeyPath: "baseName", ascending: true)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AdTableViewCell.reuseIdentifier) as! AdTableViewCell
    cell.setup(withAd: ads[indexPath.row])
    return cell
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ads.count
  }
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150.0
  }
}

import Toast_Swift

class AdTableViewCell: UITableViewCell {
  static let reuseIdentifier = "AdTableViewCell"
  
  @IBOutlet weak var adTitleLabel: UILabel!
  @IBOutlet weak var adImageView: UIImageView!
  @IBOutlet weak var stdStatusLabel: UILabel!
  @IBOutlet weak var hrStatusLabel: UILabel!
  @IBOutlet weak var stdButton: UIButton!
  @IBOutlet weak var hrButton: UIButton!
  var ad: TestAd!
  
  func setup(withAd ad: TestAd) {
    self.ad = ad
    
    adTitleLabel.text = ad.baseName
    adImageView.sd_setImage(with: URL(string: ad.thumbUrl), completed: nil)
    
    stdStatusLabel.text = ad.stdIsOnWheel ? "On Wheel" : "Off Wheel"
    stdStatusLabel.textColor = ad.stdIsOnWheel ? UIColor.gfGreen : UIColor.gfRed
    stdButton.setTitle(ad.stdIsOnWheel ? "Activate" : "Send Rad", for: .normal)
    
    hrStatusLabel.text = ad.hrRadFilePaths == nil ? "N/A" : ad.hrIsOnWheel ? "On Wheel" : "Off Wheel"
    hrStatusLabel.textColor = ad.hrIsOnWheel ? UIColor.gfGreen : UIColor.gfRed
    hrButton.setTitle(ad.hrIsOnWheel ? "Activate" : "Send Rad", for: .normal)
    hrButton.isHidden = ad.hrRadFilePaths == nil
  }
  
  @IBAction func stdButtonPressed() {
    if ad.stdIsOnWheel {
      setStdActiveOnWheel()
    } else {
      sendStdRadToWheel()
    }
  }
  
  @IBAction func hrButtonPressed() {
    if ad.hrIsOnWheel {
      setHrActiveOnWheel()
    } else {
      sendHrdRadToWheel()
    }
  }
  
  fileprivate func setStdActiveOnWheel() {
    ad.setActiveOnWheel(useHighRes: false)
  }
  
  fileprivate func setHrActiveOnWheel() {
    ad.setActiveOnWheel(useHighRes: true)
  }
  
  fileprivate func sendStdRadToWheel() {
    let result = ad.sendToWheel(adSendType: .std)
    stdButton.setLoaderVisible(visible: true, style: .white)
    
    delay(1) {
      self.stdButton.setLoaderVisible(visible: false, style: .white)
    }
    if let result = result {
      makeToast("Failed to send radial. \(result.error)")
    }
  }
  
  fileprivate func sendHrdRadToWheel() {
    let result = ad.sendToWheel(adSendType: .hr)
    hrButton.setLoaderVisible(visible: true, style: .white)
    delay(1) {
      self.hrButton.setLoaderVisible(visible: false, style: .white)
    }
    
    if let result = result {
      makeToast("Failed to send radial. \(result.error)")
    }
  }
}
