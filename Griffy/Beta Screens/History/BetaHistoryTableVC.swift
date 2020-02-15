//
//  BetaHistoryTableVC.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

struct PastRides {
  var date: Date
  var duration: Int
  var payCount: Int
}
class BetaHistoryTableVC: UITableViewController {
  var groupedShifts = [[Shift]]()
  var paymentIndices = [Int]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refreshShifts()
  }
  
  fileprivate func createFakeData(realm: Realm) {
    return()
    let durationInHours = [5.0, 8.5, 9.5, 2.3, 15.9, 16.4, 3.5, 4.3, 20.2,5.0, 8.5, 9.5, 2.3, 15.9, 16.4, 3.5, 4.3, 20.2]
    
    try! realm.write {
      let createCount = durationInHours.count
      for i in 8...createCount-1 {
        let d = realm.create(Shift.self)
        d.startDate = Date().addingTimeInterval(TimeInterval(-60*60*24*(i.double + 1.0)))
        d.endDate = d.startDate.addingTimeInterval(durationInHours[i]*60*60)
      }
    }
  }
  
  fileprivate func refreshShifts() {
    groupedShifts.removeAll()
    paymentIndices.removeAll()
    
    let realm = try! Realm()
//    createFakeData(realm: realm)
    let shifts = realm.objects(Shift.self).sorted(byKeyPath: "startDate", ascending: false)
    guard shifts.count > 0 else { return }
    var idx = 0
    groupedShifts.append([Shift]())
    shifts.forEach { (shift) in
      if groupedShifts[idx].count == 0 {
        groupedShifts[idx].append(shift)
      } else {
        if groupedShifts[idx].last?.startDate.isSameDay(date: shift.startDate) ?? false {
          groupedShifts[idx].append(shift)
        } else {
          idx += 1
          groupedShifts.append([Shift]())
          groupedShifts[idx].append(shift)
        }
      }
    }
    
    paymentIndices = groupedShifts.map({ $0.map({ $0.duration }).reduce(0, +) >= BetaConstants.minRideSecondsPerDay ? 1 : 0 })
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BetaHistoryCell.reuseIdentifier) as! BetaHistoryCell
    let summed = paymentIndices.reversed()[0...(paymentIndices.count - 1 - indexPath.row)].reduce(0, +)
    let dots = summed == 0 ? 0 : summed % 3 == 0 ? 3 : summed % 3
    cell.setup(withShifts: groupedShifts[indexPath.row], dotIndicator: dots)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groupedShifts.count
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(34)
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let cell = Bundle.main.loadNibNamed(BetaHistoryHeaderCell.reuseIdentifier, owner: self, options: nil)?.first as? BetaHistoryHeaderCell
    return cell
  }
}
