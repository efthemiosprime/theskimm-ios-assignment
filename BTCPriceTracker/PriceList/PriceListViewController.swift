//
//  PriceListViewController.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import UIKit

class PriceListViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var priceLabel: UILabel!
  
  var historicalCloseData: [String: Double] = [:]
  var historicalCloseDataKeys: [String] = []
  var priceListViewModel: PriceListViewModel = PriceListViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    refreshCurrentPrice()
    refreshHistoricalCloseData()
    
  }
    
  //MARK:- Setup
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  
  //MARK:- Refresh view
  func refreshCurrentPrice() {
  
    priceListViewModel.updateCurrentValue()
    priceListViewModel.startPolling()
    priceListViewModel.didUpdateCurrentValue = { [weak self] in
      DispatchQueue.main.async {
        self?.priceLabel?.text = self?.priceListViewModel.currentValue
      }
    }

  }
  
  func refreshHistoricalCloseData() {
    
    priceListViewModel.updateHistoricalCloseValue()
    priceListViewModel.didUpateHistoricalValue = {  [weak self] data in
      DispatchQueue.main.async {
        if let data = data {
          self?.historicalCloseData = data
          
          if let keys = self?.historicalCloseData.keys, keys.count > 0 {
            self?.historicalCloseDataKeys = Array(keys).sorted{$0 > $1}
            self?.tableView.reloadData()
          }
        }

      }
    }
  }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension PriceListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.historicalCloseData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell

    if historicalCloseDataKeys.count > 0 {
      
      let currentKey = historicalCloseDataKeys[indexPath.row]
      if let price = historicalCloseData[currentKey] {
        cell.textLabel?.text = "\(currentKey): \(String(describing: price.currencyFormatter(code: Config.Currency.USD.rawValue)) )"
      }
    }
    
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    detailViewController.detailViewModel.day = self.historicalCloseDataKeys[indexPath.row]
    self.navigationController?.pushViewController(detailViewController, animated: true)

  }
}
