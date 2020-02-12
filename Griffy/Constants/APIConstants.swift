//
//  APIConstants.swift
//  Griffy
//
//  Created by Sam Goldstein on 1/27/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation

struct APIConstants {
//  static let apiUrl: String = "http://localhost:3000/api/v2"
  #if Staging
    static let apiUrl: String = "https://staging.instructrr.com/api/v2"
  #else
    static let apiUrl: String = "https://testapp-api.bikepump.com/poc"
  #endif
  
  // api.v1.bikepum.com
  
  public static func makeEndpoint(withPath path: String) -> String {
    return "\(APIConstants.apiUrl)/\(path)"
  }
}
