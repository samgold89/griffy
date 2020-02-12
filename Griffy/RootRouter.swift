//
//  RootRouter.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class RootRouter {
  
  func showBetaLaunchScreen() {
    let vc = UIStoryboard(name: "Beta", bundle: Bundle.main).instantiateInitialViewController()!
    setRootViewController(vc)
  }
  
  func showAdminScreen() {
    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()!
    setRootViewController(vc)
  }
  
  func showBetaLoggedInScreen() {
    let vc = UIStoryboard.betaVC(betaType: .tabBar)
    setRootViewController(vc)
  }
  
  fileprivate func setRootViewController(_ vc: UIViewController) {
    let window = UIApplication.shared.windows.first
    window?.rootViewController = vc
  }
}
