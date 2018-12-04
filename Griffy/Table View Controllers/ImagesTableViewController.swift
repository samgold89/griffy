//
//  ImagesTableViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/25/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ImagesTableViewController: BaseTableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    observedIds = [CharacteristicIds.imageLoadId]
  }
}
