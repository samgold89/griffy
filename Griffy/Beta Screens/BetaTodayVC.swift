//
//  BetaTodayVC.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import Lottie
import SnapKit

class BetaTodayVC: UIViewController {
  lazy var bicyclistLottie: AnimationView = {
    let cyclist = AnimationView(name: "bicycle-delivery")
    cyclist.translatesAutoresizingMaskIntoConstraints = false
    cyclist.animationSpeed = 1.4
    cyclist.loopMode = .loop
    view.addSubview(cyclist)
    cyclist.autoSetDimensions(to: CGSize(width: 172.0, height: 152.0))
    cyclist.autoPinEdge(.bottom, to: .top, of: workingTimeLabel, withOffset: -50.0)
    cyclist.autoAlignAxis(.vertical, toSameAxisOf: view)
    return cyclist
  }()
  
  @IBOutlet weak var startRidingButton: UIButton!
  @IBOutlet weak var workingTimeLabel: UILabel!
  @IBOutlet weak var welcomeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bicyclistLottie.loopMode = .loop
    updateWelcomeLabel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateWelcomeLabel()
  }
  
  fileprivate func updateWelcomeLabel() {
    guard let me = BetaUser.me else { return }
    
    let date = Date()
    welcomeLabel.text = "Good \(date.timeOfDayDescriptor), \(me.firstName)!"
  }
  
  @IBAction func rideButtonPressed(_ sender: Any) {
    if bicyclistLottie.isAnimationPlaying {
      bicyclistLottie.stop()
      startRidingButton.backgroundColor = UIColor.gfBlue
      startRidingButton.setTitle("Start Riding", for: .normal)
    } else {
      bicyclistLottie.play()
      startRidingButton.backgroundColor = UIColor.gfRed
      startRidingButton.setTitle("Stop Riding", for: .normal)
    }
  }
  
  @IBAction func seeInstructionsPressed(_ sender: Any) {
    let vc = UIStoryboard.betaVC(betaType: .instructions)
    vc.modalPresentationStyle = .pageSheet
    vc.modalTransitionStyle = .coverVertical
    present(vc, animated: true, completion: nil)
  }
}
