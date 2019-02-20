//
//  GriffyTabBarController.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/6/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class GriffyTabBarController: UITabBarController {
  var statusView: UIView?
  
  override func viewDidLoad() {
    statusView = UIView()
    statusView!.alpha = 0
    statusView!.translatesAutoresizingMaskIntoConstraints = false
    statusView!.backgroundColor = UIColor.gfRed
    
    let label = UILabel()
    label.text = ""
    label.numberOfLines = 3
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontSizeToFitWidth = true
    label.textColor = UIColor.white
    statusView!.addSubview(label)
    label.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 55))
    
    view.addSubview(statusView!)
    
    statusView!.autoPinEdge(toSuperviewEdge: .left)
    statusView!.autoPinEdge(toSuperviewEdge: .right)
    statusView!.autoPinEdge(.bottom, to: .top, of: tabBar)
    statusView!.autoSetDimension(.height, toSize: 55)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(GriffyTabBarController.bannerTapped))
    statusView!.addGestureRecognizer(tap)
    
    let but = UIButton()
    but.backgroundColor = UIColor.red
    but.translatesAutoresizingMaskIntoConstraints = false
    but.setTitle("X", for: .normal)
    but.addTarget(self, action: #selector(GriffyTabBarController.cancelConnectionPressed), for: UIControl.Event.touchUpInside)
    statusView?.addSubview(but)
    
    but.autoPinEdge(.bottom, to: .bottom, of: statusView!, withOffset: -5)
    but.autoPinEdge(.top, to: .top, of: statusView!, withOffset: 5)
    but.autoPinEdge(.right, to: .right, of: statusView!, withOffset: -5)
    but.autoMatch(.width, to: .height, of: but, withOffset: 0)
  }
  
  @objc func cancelConnectionPressed() {
    BluetoothManager.shared.cancelGriffyConnection()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(bluetoothNotification(note:)), name: .bluetoothStateChanged, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(bluetoothNotification(note:)), name: .setBluetoothBanner, object: nil)
  }
  
  @objc func bannerTapped() {
    BluetoothManager.shared.scanForPeripherals()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func bluetoothNotification(note: Notification) {
    guard let bt = note.object as? GFBluetoothState else {
      return
    }
    statusView?.alpha = 1
    statusView?.backgroundColor = bt.color
    if let label = statusView?.subviews.first as? UILabel {
      UIView.animate(withDuration: 0.3) {
        label.text = bt.message
      }
    }
  }
}
