//
//  BetaHistoryTableVC.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class BetaHistoryTableVC: UITableViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BetaHistoryCell.reuseIdentifier) as! BetaHistoryCell
    cell.setup(forDate: Date())
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
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
  
  func setup(forDate date: Date) {
    datelabel.text = Formatters.cellDate.string(from: date)
  }
}
