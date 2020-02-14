//
//  BetaHistoryVC.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class BetaHistoryVC: UIViewController {
  
  @IBOutlet weak var greetingLabel: UILabel!
  @IBOutlet weak var codeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    codeLabel.text = BetaUser.me?.betaCode ?? "MISSING"
    updateWelcomeLabel()
  }
  
  fileprivate func updateWelcomeLabel() {
    guard let me = BetaUser.me else { return }
    
    let date = Date()
    greetingLabel.text = "Good \(date.timeOfDayDescriptor), \(me.firstName)!"
  }
}
