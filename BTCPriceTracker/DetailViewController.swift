//
//  DetailViewController.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import UIKit

class DetailViewController: UITableViewController {

  var currencies: [String:String] = ["EUR": "€", "USD": "$", "GBP": "£"]
  var selectedDay = ""
  var btcPrices = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    _ = currencies.map { currencyCode, currencySymbol in
      CoinDeskService.get(CoinDeskRequest.historicalClose(currency: currencyCode, start: selectedDay, end: selectedDay), type: HistoricalClose.self) { [weak self] (data, error) in
        guard error == nil else { return }
  
        if let price = data?.bpi.map({ $0.value})[0] {

          self?.btcPrices.append("\(currencySymbol)\(price.round(to: 2))")
          
          if let cCount = self?.currencies.count, let bCount = self?.btcPrices.count {
            if cCount == bCount {
              self?.refresh()
            }
          }

        }
      }
    }
  }
  
  // MARK: - Refresh tableview
  func refresh() {
    DispatchQueue.main.async { [weak self] in
      self?.tableView.reloadData()
    }
  }

  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return btcPrices.count
  }

  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
    cell.textLabel?.text = "\(self.btcPrices[indexPath.row])"
    return cell
  }

}
