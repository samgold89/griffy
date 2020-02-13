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
import RealmSwift

class BetaTodayVC: BaseViewController {
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
  @IBOutlet weak var codeLabel: UILabel!
  
  var completedShifts: Results<Shift>?
  var updateTimer: Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    codeLabel.text = BetaUser.me?.betaCode ?? "MISSING"
    
    updateWelcomeLabel()
    updateActionButton()
    updateLottieView()
    updateWorkingTime()
    
    LocationManager.shared.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    updateWelcomeLabel()
    updateActionButton()
  }
  
  @objc fileprivate func appBecameActive() {
    updateLottieView()
  }
  
  fileprivate func updateLottieView() {
    let name = LocationManager.shared.permissionStatus == .enabled ? LottieFiles.cyclist : LottieFiles.locationServices
    bicyclistLottie.animation = Animation.named(name)
    if name == LottieFiles.locationServices {
      bicyclistLottie.play()
    } else {
      LocationManager.shared.isUpdatingLocation ? bicyclistLottie.play() : bicyclistLottie.stop()
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
        stopShift()
      } else {
        startShift()
      }
      updateActionButton()
    } else if LocationManager.shared.permissionStatus == .denied {
      showSettings(alertTitle: "Location Denied", alertBody: "In order to enable location permissions, you'll need to go to Settings > Privacy > Enable Locations for this app.", goButton: "Settings", cancelButton: "Cancel")
    } else {
      LocationManager.shared.requestLocationPermission()
      startRidingButton.startAnimate(spinnerType: .ballRotateChase, spinnercolor: .white, spinnerSize: 30, complete: nil)
    }
  }
  
  //MARK: Shift Management
  fileprivate func beginTimer() {
    updateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
      self.updateWorkingTime()
    }
  }
  
  fileprivate func endTimer() {
    updateTimer?.invalidate()
    updateTimer = nil
  }
  
  fileprivate func updateWorkingTime() {
    let loggedTime = completedShifts?.compactMap({ $0.duration }).reduce(0, +) ?? 0
    let newTime = Shift.currentShift?.duration ?? 0
    workingTimeLabel.text = String.hourMinSecFromSeconds(time: loggedTime + newTime)
  }
  
  fileprivate func startShift() {
    LocationManager.shared.startUpdatingLocation()
    bicyclistLottie.play()
    Shift.endCurrentShift() // IN case we're coming back from a dead or crashed app
    
    let realm = try! Realm()
    completedShifts = realm.objects(Shift.self).filter(NSPredicate(format: "endDate != nil AND startDate >= %@", argumentArray: [Date().dateAtStartOf(Calendar.Component.day)]))
    
    Shift.beginNewShift()
    beginTimer()
  }
  
  fileprivate func stopShift() {
    LocationManager.shared.stopUpdatingLocation()
    bicyclistLottie.stop()
    Shift.endCurrentShift()
    endTimer()
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
