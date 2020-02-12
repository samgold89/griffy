//
//  FontExtensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

enum BetaVCTypes: String {
  case intro = "BetaWelcomeVC"
  case setup = "BetaSetupVC"
  case instructions = "BetaInstructionsVC"
  
  case tabBar = "BetaTabBarVC"
}

extension UIStoryboard {
  internal static func betaVC(betaType: BetaVCTypes) -> UIViewController {
    return UIStoryboard.init(name: "Beta", bundle: Bundle.main).instantiateViewController(withIdentifier: betaType.rawValue)
  }
}
