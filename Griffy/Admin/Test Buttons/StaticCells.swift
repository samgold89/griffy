//
//  StaticCells.swift
//  Griffy
//
//  Created by Sam Goldstein on 3/11/20.
//  Copyright © 2020 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class TestButtonsTableViewController: UITableViewController {
  
  //Fetch Ads
  @IBOutlet weak var getAdsButton: UIButton!
  @IBOutlet weak var resultsLabel: UILabel!
  
  @IBAction func buttonPressed(button: UIButton) {
    getAdsButton.setLoaderVisible(visible: true, style: .white)
    NetworkManager.shared.getTestAds { (error) in
      self.getAdsButton.setLoaderVisible(visible: false, style: nil)
      if let e = error {
        self.resultsLabel.text = "Error fetching ads: \(e.error)"
      } else {
        self.resultsLabel.text = "Successfully fetched ads!"
      }
    }
  }
  
  // Logging
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var clearButton: UIButton!
  @IBOutlet weak var fetchButton: UIButton!
  
  fileprivate func showLoggingPeriodAlert(completion: @escaping (Int?)->()) {
    let defaultLoggingPeriod = "256"
    let alert = UIAlertController(title: "Logging Period", message: "What should it be? (Default is 256)", preferredStyle: UIAlertController.Style.alert)
    alert.addTextField { (tf) in
      tf.text = defaultLoggingPeriod
    }
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (ac) in
      completion(nil)
    }))
    alert.addAction(UIAlertAction(title: "Set", style: .default, handler: { (ac) in
      let intText = Int(alert.textFields?.first?.text ?? defaultLoggingPeriod)
      completion(intText)
    }))
    present(alert, animated: true, completion: nil)
  }
  
  //  To Start Logging
  //  1. Select Log (0 or 1)
  //  2. Update Period (this starts logging - Start with 256 = 25.6ms We may not be able to sustain lower numbers...needs test)
  //  3. Change Period to zero (this stops logging)
  
  @IBAction func startLoggingPressed(_ sender: Any) {
    guard let logPeriod = GFCharacteristic.loggingPeriod, let activeLog = GFCharacteristic.activeLog, let clockTick = GFCharacteristic.logClockTickReset else { return }
    
    showLoggingPeriodAlert { (loggingValue) in
      guard let loggingValue = loggingValue else { return }
      
      self.startButton.setLoaderVisible(visible: true, style: .white)
      //    let nextLog = Int(activeLog.griffyDisplayValue ?? "1") == 0 ? 1 : 0
      
      // Initially, we'll only read & write to log 0 for simplicity.
      BluetoothManager.shared.writeValue(data: activeLog.bleObject.dataValue(fromInt: 0) , toCharacteristic: activeLog)
      BluetoothManager.shared.writeValue(data: logPeriod.bleObject.dataValue(fromInt: loggingValue), toCharacteristic: logPeriod)
      BluetoothManager.shared.writeValue(data: clockTick.bleObject.dataValue(fromInt: 0) , toCharacteristic: clockTick, completion: {
        self.startButton.setLoaderVisible(visible: false, style: nil)
      })
    }
  }
  
  @IBAction func stopLoggingPressed(_ sender: Any) {
    guard let logPeriod = GFCharacteristic.loggingPeriod else { return }
    stopButton.setLoaderVisible(visible: true, style: .white)
    BluetoothManager.shared.writeValue(data: UInt16(0).data , toCharacteristic: logPeriod)
    delay(0.5) {
      self.stopButton.setLoaderVisible(visible: false, style: nil)
    }
  }
  
  @IBAction func clearLogPressed(_ sender: Any) {
    clearButton.setLoaderVisible(visible: true, style: .white)
  }
  
  @IBAction func fetchLogPressed(_ sender: Any) {
    //  To Read logs
    //  1. Select the opposite of the log you used before.
    //  2. Read Load characteristic
    //  3. Stop when you read 0xFFFFF... in entry
    //  You could read and log same time. Read is always coming from the Inactive log.
    //  When I set the activeLog to be 1, this resets the readIndex of Log0
    
    guard let activeLog = GFCharacteristic.activeLog else { return }
    fetchButton.setLoaderVisible(visible: true, style: .white)
    
    BluetoothManager.shared.writeValue(data: activeLog.bleObject.dataValue(fromInt: 1) , toCharacteristic: activeLog)
    BluetoothManager.shared.readLog()
    
    delay(0.5) {
      self.fetchButton.setLoaderVisible(visible: false, style: nil)
    }
  }
}
