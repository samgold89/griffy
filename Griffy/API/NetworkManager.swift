//
//  NetworkManager.swift
//  Griffy
//
//  Created by Sam Goldstein on 1/27/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import Reachability

public struct NetworkFailClosure {
  var error: String
  var errorTitle: String?
  var statusCode: Int
}

enum SlackChannels: String {
  case sam = ""
  case errors = "a"
}

final class NetworkManager {
  static let shared = NetworkManager()
  var sessionManager: SessionManager?
  let reachability = try! Reachability()
  
  private init() {
    setupSessionManager()
    setupReachability()
  }
  
  func getSessionHeaders() -> [String: Any]! {
    var headers = [String: Any]()
    
    if let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
      headers["App-Build"] = appBuild
    }
    
    return headers
  }
  
  func setupSessionManager() {
    // get the default headers
    var headers = Alamofire.SessionManager.defaultHTTPHeaders
    
    // Edit headers here
    
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = headers
    
    // create a session manager with the configuration
    sessionManager = Alamofire.SessionManager(configuration: configuration)
  }
  
  func setupReachability() {
    do {
      try reachability.startNotifier()
    } catch {
      assertionFailure("Unable to start notifier\n\(error)")
    }
  }
  
  //MARK: Base Methods
  func makeRequestOfType(_ method: HTTPMethod, endpoint: String, params: [String: Any]?, extraHeaders: [String: Any]?, success: @escaping (AnyObject)->(), failure: @escaping (NetworkFailClosure)->()) {
    
    guard let session = sessionManager else { return }
    
    let requestSummary = "API Call - \(method) - \(endpoint)\n\(params ?? ["no":"params"])"
    print("\n\n\(requestSummary)")
    
    var customHeaders = getSessionHeaders()
    customHeaders?.merge(extraHeaders ?? [String: Any](), uniquingKeysWith: { (_, extra) -> Any in extra })
    
    let head = customHeaders as! HTTPHeaders
    
//    let newEndpoint = endpoint.replacingOccurrences(of: "+", with: "%2B")
    
    session.request(endpoint, method: method, parameters: params, encoding: JSONEncoding.default, headers: head).responseJSON { (response) in
      
      let statusCode = response.response?.statusCode ?? 0
      if statusCode == 419 {
        //Unauthorized Access
        print("🛑 Failed: Unauthorzied Access\n\(requestSummary)\n")
        failure(NetworkFailClosure(error: "Unauthorized Access", errorTitle: nil, statusCode: statusCode))
        return
      } else if (statusCode >= 400 || statusCode == 0) {
        //error
        let errorMsg = ErrorConstants.networkError
        var error = NetworkFailClosure(error: errorMsg, errorTitle: nil, statusCode: statusCode)
        if let dict  = response.result.value as? [String: Any] {
          let parsedError = self.errorStringForResults(dict)
          error.errorTitle = parsedError.errorTitle
          error.error = parsedError.error
        }
        print("\n🛑 Request failed with error: \(error)\n\(requestSummary)")
        failure(error)
      } else {
        print("\n✅ Success 🎊!!\n\(requestSummary)\n\n")
        success(response.result.value as AnyObject)
      }
    }
  }
  
  func errorStringForResults(_ results: [String: Any]) -> NetworkFailClosure {
    var error = ErrorConstants.networkError
    if let thisError = results["errors"] as? [String] {
      for additionalError in thisError {
        if additionalError == thisError.first {
          error = "\(additionalError)"
        } else {
          error = "\(error)\n\(additionalError)"
        }
      }
    } else if let thisError = results["error"] as? String {
      error = thisError
    } else  {
      guard let errorsDict = results["error"] as? [String: Any] else {
        return NetworkFailClosure(error: error, errorTitle: nil, statusCode: 0)
      }
      
      if let errs = errorsDict["errors"] as? [[String: Any]] {
        if let msg = errs[0]["message"] as? String {
          error = msg
        }
      }
    }
    
    let title = results["title"] as? String
    return NetworkFailClosure(error: error, errorTitle: title, statusCode: 0)
  }
  
  func sendLocations() {
    
    //
    
    let endpoint = APIConstants.makeEndpoint(withPath: "locations")
    let params = [
      "locations":
        [["latitude": Double(37.771102),
         "longitude": Double(-122.432589),
         "client_uuid": "88eb7cc2-112d-412b-bdd5-2ae79e525754",
         "horizontal_accuracy": Double(1234.1),
         "speed": Double(23.1),
         "course": Double(98.123456),
         "nickname": "Miguel Enriquez", 
         "timestamp": "2020-01-27 12:34:56"]]
      ] as [String : Any]
    
    makeRequestOfType(.post, endpoint: endpoint, params: params, extraHeaders: nil, success: { (response) in
      print("We out here")
    }) { (error) in
      print(error)
    }
  }
}
