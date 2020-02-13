//
//  ViewControllerExtensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/12/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  func showSettings(alertTitle: String, alertBody: String, goButton: String, cancelButton: String) {
    let alertController = UIAlertController (title: alertTitle, message: alertBody, preferredStyle: .alert)
    
    let settingsAction = UIAlertAction(title: goButton, style: .default) { (_) -> Void in
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
      }
      
      if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
      }
    }
    alertController.addAction(settingsAction)
    let cancelAction = UIAlertAction(title: cancelButton, style: .default, handler: nil)
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true, completion: nil)
  }
}
