//
//  StaticCells.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class GetAdsCell: UITableViewCell {
  @IBAction func buttonPressed() {
    NetworkManager.shared.getTestAds { (error) in
      if let e = error {
        print(e.error)
      } else {
        
      }
    }
  }
}
