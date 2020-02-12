//
//  FontExtensions.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
  
  public static func printAllBundledFonts() {
    for family: String in UIFont.familyNames {
      print(family)
      for names: String in UIFont.fontNames(forFamilyName: family) {
        print("== \(names)")
      }
    }
  }
  
  public static func griffyBlack(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-Black", size: size)!
  }
  public static func griffyBlackItalic(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-BlackItalic", size: size)!
  }
  public static func griffyBold(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-Bold", size: size)!
  }
  public static func griffyBoldItalic(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-BoldItalic", size: size)!
  }
  public static func griffyExtraBold(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-ExtraBold", size: size)!
  }
  public static func griffyExtraBoldItalic(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-ExtraBoldItalic", size: size)!
  }
  public static func griffyExtraLight(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-ExtraLight", size: size)!
  }
  public static func griffyExtraLightItalic(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-ExtraLightItalic", size: size)!
  }
  public static func griffyItalic(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-Italic", size: size)!
  }
  public static func griffyLight(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-Light", size: size)!
  }
  public static func griffyLightItalic(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-LightItalic", size: size)!
  }
  public static func griffyMedium(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-Medium", size: size)!
  }
  public static func griffyMediumItalic(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-MediumItalic", size: size)!
  }
  public static func griffyRegular(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-Regular", size: size)!
  }
  public static func griffySemiBold(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-SemiBold", size: size)!
  }
  public static func griffySemiBoldItalic(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-SemiBoldItalic", size: size)!
  }
  public static func griffyThin(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-Thin", size: size)!
  }
  public static func griffyThinItalic(size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-ThinItalic", size: size)!
  }
}
