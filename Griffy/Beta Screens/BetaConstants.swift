//
//  BetaConstants.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation

struct BetaConstants {
  static let minRideSecondsPerDay = 6 * 60 * 60
  static let riderDaySurveyUrl = "https://docs.google.com/forms/d/e/1FAIpQLSfurAQI1CPthCuo0-2hWMO77mEngHWPxS_XOunDRd4Bw1R9tg/viewform?usp=pp_url&entry.592864392=\(BetaUser.me?.betaCode ?? "Beta Code")"
  static let minimumHorizontalAccuracy = 1000.double
}
