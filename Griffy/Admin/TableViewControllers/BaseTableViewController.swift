//
//  BaseTableViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/3/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class BaseTableViewController: UITableViewController {
  var observedCharacteristics: Results<GFCharacteristic>?
  var token: NotificationToken?
  var observedIds: [String] = [] {
    didSet {
      let realm = try! Realm()
      observedCharacteristics = realm.objects(GFCharacteristic.self).filter(NSPredicate(format: "id IN %@", observedIds))
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    BluetoothManager.shared.startUpdateTimer()
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    token = observedCharacteristics?.GFObseveDataChanges(for: tableView, animateChanges: true)
    if let observedCharacteristics = observedCharacteristics {
      BluetoothManager.shared.visibleCharacteristics = Array(observedCharacteristics)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    token?.invalidate()
    
    //If we're moving to a non-base-tableview-page, we'll nil it out
    //Else the updated values will be updated based on the new vc
    if let observedCharacteristics = observedCharacteristics {
      if BluetoothManager.shared.visibleCharacteristics == Array(observedCharacteristics) {
        BluetoothManager.shared.visibleCharacteristics = nil
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =
      tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    configureCell(cell, withIndexPath: indexPath)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CharacteristicDetailViewController") as? CharacteristicDetailViewController {
      let idx = tableView.indexPathForSelectedRow?.row ?? 0
      guard let char = observedCharacteristics?[idx] else {
        return
      }
      vc.characteristicId = char.id
      navigationController?.pushViewController(vc, animated: true)
    }
  }
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if let vc = segue.destination as? CharacteristicDetailViewController {
//      
//    }
//  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return observedCharacteristics?.count ?? 0
  }
  
  func configureCell(_ cell: UITableViewCell, withIndexPath indexPath: IndexPath) {
    guard let observedCharacteristics = observedCharacteristics else {
      assertionFailure("YOYOYO should have a thing in th eobserv oskjf")
      return
    }
    
    let char = observedCharacteristics[indexPath.row]
    cell.textLabel!.text = char.name
    if let value = char.value?.griffyDisplayValue(characteristicId: char.uuid) {
      cell.detailTextLabel?.text = value
    } else {
      cell.detailTextLabel?.text = "👎🏽"
    }
  }
}
