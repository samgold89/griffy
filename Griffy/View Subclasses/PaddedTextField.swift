//
//  PaddedTextField.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class PaddedTextField: UITextField {
  
  @IBInspectable public var leftTextInset: CGFloat = 0 {
    didSet { setNeedsDisplay() }
  }
  
  @IBInspectable public var rightTextInset: CGFloat = 0 {
    didSet { setNeedsDisplay() }
  }
  
  open override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: 0, left: leftTextInset, bottom: 0, right: rightTextInset))
  }
  
  open override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: 0, left: leftTextInset, bottom: 0, right: rightTextInset))
  }
  
  open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: 0, left: leftTextInset, bottom: 0, right: rightTextInset))
  }
}
