//
//  ViewExtensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  static let confettiTag = 8238422
  
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.masksToBounds = newValue > 0
      layer.cornerRadius = newValue
    }
  }
  
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
  
  @IBInspectable var borderColor: UIColor {
    get {
      return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
    }
    set {
      layer.borderColor = newValue.cgColor
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  func snapshotAsImage() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
    let _ = drawHierarchy(in: bounds, afterScreenUpdates: true)
    let snap = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return snap
  }
}
