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
import SSSpinnerButton

class BetaTodayVC: UIViewController {
  lazy var bicyclistLottie: AnimationView = {
    let name = LocationManager.shared.permissionStatus == .enabled ? LottieFiles.cyclist : LottieFiles.locationServices
    let cyclist = AnimationView(name: name)
    cyclist.translatesAutoresizingMaskIntoConstraints = false
    cyclist.animationSpeed = 1.4
    cyclist.loopMode = .loop
    view.addSubview(cyclist)
    cyclist.autoSetDimensions(to: CGSize(width: 172.0, height: 152.0))
    cyclist.autoPinEdge(.bottom, to: .top, of: workingTimeLabel, withOffset: -50.0)
    cyclist.autoAlignAxis(.vertical, toSameAxisOf: view)
    return cyclist
  }()
  
  @IBOutlet weak var startRidingButton: SSSpinnerButton!
  @IBOutlet weak var workingTimeLabel: UILabel!
  @IBOutlet weak var welcomeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bicyclistLottie.loopMode = .loop
    updateWelcomeLabel()
    updateActionButton()
    LocationManager.shared.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateWelcomeLabel()
    updateActionButton()
  }
  
  fileprivate func updateLottieView() {
    let isPlaying = bicyclistLottie.isAnimationPlaying
    let name = LocationManager.shared.permissionStatus == .enabled ? LottieFiles.cyclist : LottieFiles.locationServices
    bicyclistLottie.animation = Animation.named(name)
    if name == LottieFiles.locationServices {
      bicyclistLottie.play()
    } else {
      isPlaying ? bicyclistLottie.play() : bicyclistLottie.stop()
    }
  }
  
  fileprivate func updateWelcomeLabel() {
    guard let me = BetaUser.me else { return }
    
    let date = Date()
    welcomeLabel.text = "Good \(date.timeOfDayDescriptor), \(me.firstName)!"
  }
  
  @IBAction func rideButtonPressed(_ sender: Any) {
    if LocationManager.shared.permissionStatus == .enabled {
      if LocationManager.shared.isUpdatingLocation {
        LocationManager.shared.stopUpdatingLocation()
        bicyclistLottie.stop()
      } else {
        LocationManager.shared.startUpdatingLocation()
        bicyclistLottie.play()
      }
      updateActionButton()
    } else {
      LocationManager.shared.requestLocationPermission()
      startRidingButton.startAnimate(spinnerType: .ballRotateChase, spinnercolor: .white, spinnerSize: 30, complete: nil)
    }
  }
  
  fileprivate func updateActionButton() {
    if LocationManager.shared.permissionStatus == .enabled {
      if LocationManager.shared.isUpdatingLocation {
        startRidingButton.backgroundColor = UIColor.gfRed
        startRidingButton.setTitle("Stop Riding", for: .normal)
      } else {
        startRidingButton.backgroundColor = UIColor.gfBlue
        startRidingButton.setTitle("Start Riding", for: .normal)
      }
    } else {
      startRidingButton.setTitle("Enable Location", for: .normal)
    }
  }
  
  @IBAction func seeInstructionsPressed(_ sender: Any) {
    let vc = UIStoryboard.betaVC(betaType: .instructions)
    vc.modalPresentationStyle = .pageSheet
    vc.modalTransitionStyle = .coverVertical
    present(vc, animated: true, completion: nil)
  }
}

extension BetaTodayVC: GFLocationProtocol {
  func locationSaved(location: Location) {
    
  }
  
  func locationTrackingChanged(isPaused: Bool) {
    
  }
  
  func permissionsUpdated(status: GFLocationPermissions) {
    if status == .unknown { return }
    
    updateLottieView()
    updateActionButton()
    
    startRidingButton.stopAnimatingWithCompletionType(completionType: .none, complete: nil)
    delay(0.5) {
      self.updateActionButton()
    }
  }
}
