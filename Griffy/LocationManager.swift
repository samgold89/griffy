//
//  LocationManager.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: CLLocationManager {
  static let shared = LocationManager()
  
  private override init() {
    super.init()
    allowsBackgroundLocationUpdates = true
    pausesLocationUpdatesAutomatically = false
    distanceFilter = kCLDistanceFilterNone
    desiredAccuracy = kCLLocationAccuracyBest
    activityType = .fitness
  }
}
