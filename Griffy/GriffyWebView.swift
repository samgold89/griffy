//
//  GriffyWebView.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import WebKit

class GriffyWebView: WKWebView {
  convenience init(includeUserAgent: Bool) {
    self.init()
    
//    let userAgent = "iOS-\(HandstandUser.myHandstandUserId() == "0" ? "iOS-NO-USER" : HandstandUser.myHandstandUserId())"
//    customUserAgent = userAgent
    
//    clearCache()
  }
  
  func load(_ urlString: String) {
    if let url = URL(string: urlString) {
      let request = URLRequest(url: url)
      load(request)
    } else {
      assertionFailure("Having trouble making a url from the sring \(urlString)")
    }
  }
  
  func clearCache() {
    let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
    let date = NSDate(timeIntervalSince1970: 0)
    
    WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
  }
}
