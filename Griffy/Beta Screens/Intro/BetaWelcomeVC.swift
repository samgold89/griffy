//
//  BetaWelcomeVC.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class BetaWelcomeVC: UIViewController {
  
  @IBAction func nextButtonPressed(_ sender: Any) {
    present(UIStoryboard.betaVC(betaType: .setup), animated: true, completion: nil)
  }
}
