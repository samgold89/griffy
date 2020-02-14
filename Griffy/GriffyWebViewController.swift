//
//  GriffyWebViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 2/13/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import WebKit

class GriffyWebViewController: UIViewController {
  var webView: GriffyWebView?
  var url: String?
  var loadingMessage: String?
  
  convenience init(url: String) {
    self.init()
    self.url = url
  }
  
  convenience init(url: String, loadingMessage: String?) {
    self.init()
    self.url = url
    self.loadingMessage = loadingMessage
  }
  
  override func loadView() {
    let webView = setupWebView()
    self.view = webView
  }
  
  @objc func dismissNav() {
    dismiss(animated: true, completion: nil)
  }
  
  func setupWebView() -> GriffyWebView {
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(GriffyWebViewController.dismissNav))
    //    let config = WKWebViewConfiguration()
    //    config.dataDetectorTypes = [.all]
    
    //    let webView = HuntWebView(frame: .zero, configuration: config)
    let webView = GriffyWebView(includeUserAgent: true)
    webView.load(url ?? "")
//    webView.navigationDelegate = self
//    webView.uiDelegate = self
    
//    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
//    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    
    self.webView = webView
    return webView
  }
  
//  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//    if keyPath == "estimatedProgress" {
//      print(Float(webView?.estimatedProgress ?? -1.0))
//      if !isBeingDismissed && !isShowingHuntLoader {
//        showHuntLoader(loadingMessage: loadingMessage)
//      }
//      let progress = webView?.estimatedProgress ?? 0.0
//      if progress >= 1 {
//        dismissHuntLoader()
//      }
//    }
//  }
}

extension GriffyWebViewController: WKNavigationDelegate {
  
//  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//    decisionHandler(.allow)
//  }
//
//  func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//    let creds = URLCredential(user: "handstand", password: "loveya", persistence: .forSession)
//    completionHandler(.useCredential, creds)
//  }
}

extension GriffyWebViewController: WKUIDelegate {
//  func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//    showAlertWithTitle(title: "Web Alert", body: message, buttonTitles: ["OK"])
//    completionHandler()
//  }
}

