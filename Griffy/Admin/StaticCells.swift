//
//  StaticCells.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class TestButtonsTableViewController: UITableViewController {
  @IBOutlet weak var getAdsButton: UIButton!
  @IBAction func buttonPressed(button: UIButton) {
    getAdsButton.setLoaderVisible(visible: true, style: .white)
    NetworkManager.shared.getTestAds { (error) in
      self.getAdsButton.setLoaderVisible(visible: false, style: nil)
      if let e = error {
        print(e.error)
      } else {
        
      }
    }
  }
}
