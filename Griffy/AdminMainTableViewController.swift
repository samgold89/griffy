//
//  AdminMainTableViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/25/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AdminMainTableViewController: UITableViewController {
  var observedCharacteristics: Results<GFCharacteristic>?
  let observedIds = [CharacteristicIds.imageSelectId, CharacteristicIds.wheelSpeedId, CharacteristicIds.percentageChargeId]
  
  var token: NotificationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let realm = try! Realm()
    observedCharacteristics = realm.objects(GFCharacteristic.self).filter(NSPredicate(format: "id IN %@", observedIds))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    token = observedCharacteristics?.GFObseveDataChanges(for: tableView, animateChanges: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    token?.invalidate()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? CharacteristicDetailViewController {
      let idx = tableView.indexPathForSelectedRow?.row ?? 0
      guard let char = observedCharacteristics?[idx] else {
        return
      }
      vc.characteristicId = char.id
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return observedCharacteristics?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    configureCell(cell, withIndexPath: indexPath)
    return cell
  }
  
  func configureCell(_ cell: UITableViewCell, withIndexPath indexPath: IndexPath) {
    guard let observedCharacteristics = observedCharacteristics else {
      assertionFailure("YOYOYO should have a thing in th eobserv oskjf")
      return
    }
    
    let char = observedCharacteristics[indexPath.row]
    cell.textLabel!.text = char.name
    if let value = char.value?.griffyValue(characteristicId: char.uuid) {
      cell.detailTextLabel?.text = "\(value)"
    } else {
      cell.detailTextLabel?.text = "👎🏽"
    }
  }  
}
