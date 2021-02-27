//
//  DetailViewController.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import UIKit

class DetailViewController: UITableViewController {

  var detailViewModel = DetaillViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    detailViewModel.didUpdate = { [weak self] in
      DispatchQueue.main.async {
        self?.refresh()
      }
    }
    
  }
  
  // MARK: - Refresh tableview
  func refresh() {
    tableView.reloadData()
  }

  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return detailViewModel.btcPrices.count
  }

  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
    cell.textLabel?.text = "\(self.detailViewModel.btcPrices[indexPath.row])"
    return cell
  }

}
 
