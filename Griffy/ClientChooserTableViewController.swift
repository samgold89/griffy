//
//  ClientChooserTableViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/28/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDropbox

class ClientChooserTableViewController: UITableViewController {
  
  var clientFolders: Files.ListFolderResult?
  let dbxClientPath = "/Griffy App/clients_in_app"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = UIColor.lightText
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    view.backgroundColor = UIColor.lightText
    
    loadDropboxData()
  }
  
  func loadDropboxData() {
    if let cli = DropboxClientsManager.authorizedClient {
      cli.files.listFolder(path: dbxClientPath).response(completionHandler: { (result, error) in
        self.clientFolders = result
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
      })
    } else {
      DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: {(url: URL) -> Void in
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      })
    }
  }
  
  @IBAction func refreshDropbox(_ sender: Any) {
    clientFolders = nil
    tableView.reloadData()
    loadDropboxData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return clientFolders?.entries.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClientChooserTableViewCell", for: indexPath) as? ClientChooserTableViewCell, let clientFolders = clientFolders else {
      assertionFailure("ClientChooserTableViewCell note dequeuing properly OR client folders is empty...")
      return UITableViewCell()
    }
    
    let info = clientFolders.entries[indexPath.row]
    guard let pathLower = info.pathLower else {
      assertionFailure("missing path lower in client folders")
      return cell
    }
    let client = GriffyDropboxClient(clientName: info.name, path: pathLower)
    cell.setupCellWithClient(client)
    cell.selectionStyle = GriffyFileManager.clientExists(client: client.clientName) ? .gray : .none
    return cell
  }
}

//MARK: Dropbox Methods
