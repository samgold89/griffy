//
//  BetaHistoryCell.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class BetaHistoryHeaderCell: UITableViewHeaderFooterView {
  static let reuseIdentifier = "BetaHistoryHeaderCell"
}

class BetaHistoryCell: UITableViewCell {
  static let reuseIdentifier = "BetaHistoryCell"
  
  @IBOutlet weak var datelabel: UILabel!
  
  @IBOutlet weak var workingTimeLabel: UILabel!
  @IBOutlet weak var failureLabel: UILabel!
  @IBOutlet weak var moneyLabel: UILabel!
  
  @IBOutlet weak var leftDot: UIView!
  @IBOutlet weak var middleDot: UIView!
  @IBOutlet weak var rightDot: UIView!
  
  func setup(withShifts shifts: [Shift], dotIndicator: Int) {
    guard let firstShift = shifts.first else { return }
    datelabel.text = Formatters.cellDate.string(from: firstShift.startDate)
    
    let totalDuration = shifts.map({$0.duration}).reduce(0, +)
    workingTimeLabel.text = String.hourMinSecFromSeconds(time: totalDuration)
    let isFullDay = totalDuration >= BetaConstants.minRideSecondsPerDay
    if isFullDay {
      if #available(iOS 13.0, *) {
        workingTimeLabel.textColor = UIColor.label
      } else {
        workingTimeLabel.textColor = UIColor.black
      }
      failureLabel.text = nil
    } else {
      workingTimeLabel.textColor = UIColor.gfRed
      failureLabel.text = "Log \(BetaConstants.minRideSecondsPerDay.howManyHours(forceTwoDigits: false))hrs minimum!"
    }
    
    moneyLabel.isHidden = true
    switch dotIndicator {
    case 0:
      leftDot.backgroundColor = UIColor.clear
      middleDot.backgroundColor = UIColor.clear
      rightDot.backgroundColor = UIColor.clear
    case 1:
      leftDot.backgroundColor = UIColor.gfBlue
      middleDot.backgroundColor = UIColor.clear
      rightDot.backgroundColor = UIColor.clear
    case 2:
      leftDot.backgroundColor = UIColor.gfBlue
      middleDot.backgroundColor = UIColor.gfBlue
      rightDot.backgroundColor = UIColor.clear
    case 3:
      leftDot.backgroundColor = UIColor.gfBlue
      middleDot.backgroundColor = UIColor.gfBlue
      rightDot.backgroundColor = UIColor.gfBlue
      moneyLabel.isHidden = isFullDay ? false : true
    default:
      assertionFailure("Nada")
    }
    
    layoutIfNeeded()
  }
}
