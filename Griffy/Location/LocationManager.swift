//
//  LocationManager.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import CoreLocation

enum GFLocationPermissions {
  case enabled
  case disabled
  case unknown
}

protocol GFLocationProtocol: class {
  func locationSaved(location: Location)
  func permissionsUpdated(status: GFLocationPermissions)
  func locationTrackingChanged(isPaused: Bool)
}

class LocationManager: NSObject {
  
  static let shared = LocationManager()
  weak var delegate: GFLocationProtocol?
  private var currentlyUpdatingLocation: Bool = false
  
  lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.pausesLocationUpdatesAutomatically = false
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.activityType = .fitness
    locationManager.delegate = self
    return locationManager
  }()
  
  private override init() {
    super.init()
  }
  
//  MARK: Property Getters
  
  var permissionStatus: GFLocationPermissions {
    return gfStatus(fromAuthorizationStatus: CLLocationManager.authorizationStatus())
  }
  
  var isUpdatingLocation: Bool {
    return currentlyUpdatingLocation
  }
  
//  MARK: Location Start & Stop Methods
  func requestLocationPermission() {
    locationManager.requestAlwaysAuthorization()
  }
  
  func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
    currentlyUpdatingLocation = true
  }
  
  func stopUpdatingLocation() {
    locationManager.stopUpdatingLocation()
    locationManager.stopUpdatingHeading()
    currentlyUpdatingLocation = false
  }
  
  func gfStatus(fromAuthorizationStatus status: CLAuthorizationStatus) -> GFLocationPermissions {
    switch status {
    case .notDetermined:
      return .unknown
    case .denied, .restricted:
      return .disabled
    default:
      return .enabled
    }
  }
}

// MARK: LocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
  func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
    delegate?.locationTrackingChanged(isPaused: false)
  }
  
  func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
    delegate?.locationTrackingChanged(isPaused: true)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locations.filter({ $0.horizontalAccuracy <= 20 }).forEach { (loc) in
      let id = Location.create(withLocation: loc)
      if let location = Location.find(byId: id) {
        delegate?.locationSaved(location: location)
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    let permission = gfStatus(fromAuthorizationStatus: status)
    delegate?.permissionsUpdated(status: permission)
  }
}
