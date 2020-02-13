//
//  BetaInstructionsVC.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class BetaInstructionsVC: UIViewController {
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var welcomeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let me = BetaUser.me {
      welcomeLabel.text = "Welcome, \(me.firstName)"
    }
  }
  
  @IBAction func nextButtonPressed(_ sender: Any) {
    if presentingViewController?.isKind(of: BetaTabBarVC.self) ?? false {
      dismiss(animated: true, completion: nil)
    } else {
      RootRouter().showBetaLoggedInScreen()
    }
  }
  
  @IBAction func seePolicyPressed(_ sender: Any) {
    
  }
}
