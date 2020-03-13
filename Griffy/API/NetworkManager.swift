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
  var sendingLocations = false
  
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
  func makeRequestOfType(_ method: HTTPMethod, endpoint: String, params: [String: Any]?, extraHeaders: [String: Any]?, printParams: Bool = true, success: @escaping (AnyObject)->(), failure: @escaping (NetworkFailClosure)->()) {
    
    guard let session = sessionManager else { return }
    
    let requestSummary = "API Call - \(method) - \(endpoint)\n\(printParams ? (params ?? ["no":"params"]) : [String: Any]())"
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
  
  func sendLocations(locations: [Location]) {
    if sendingLocations { return }
    sendingLocations = true
    
    let endpoint = APIConstants.makeEndpoint(withPath: "locations")
    
    let locParams = locations.map { (loc) -> [String: Any] in
      ["latitude": loc.latitude,
      "longitude": loc.longitude,
      "client_uuid": BetaUser.me?.id ?? "*MISSING-ID*",
      "horizontal_accuracy": loc.horizontalAccuracy,
      "speed": loc.speed,
      "course": loc.course,
      "nickname": BetaUser.me?.betaCode ?? "**MISSING CODE**",
      "timestamp":  Formatters.locationDate.string(from: loc.timestamp)]
    }
    
    let params = ["locations": locParams]
    print("🗺 Sending \(locations.count) locations")
    makeRequestOfType(.post, endpoint: endpoint, params: params, extraHeaders: nil, printParams: false, success: { (response) in
      locations.forEach({ $0.markSent() })
      self.sendingLocations = false
    }) { (error) in
      print(error)
      self.sendingLocations = false
    }
  }
  
  func getTestAds(completion: @escaping (NetworkFailClosure?)->()) {
    let displayType = "A78"
    let userId = "123"
    let endpoint = APIConstants.makeEndpoint(withPath: "testAds?displayFormat=\(displayType)&userId=\(userId)")
    makeRequestOfType(.get, endpoint: endpoint, params: nil, extraHeaders: nil, success: { (resp) in
      guard let resp = resp as? [String: Any], let ads = resp["testAds"] as? [[String: Any]] else { return }
      ads.forEach { (ad) in
        TestAd.parse(TestAd.self, dictionary: ad) else { return }
      }
      completion(nil)
    }) { (error) in
      completion(NetworkFailClosure(error: error.error, errorTitle: error.errorTitle, statusCode: error.statusCode))
    }
  }
}
