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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    
    refreshCurrentPrice()
  }
    
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func getCurrentPrice(_ completion: @escaping (CurrentPrice?) -> ()) {

    CoinDeskService.get(CoinDeskRequest.currentPrice, type: CurrentPrice.self) { (data, error) in
      guard error == nil else { return }
      completion(data ?? nil)
    }
  }
  
  @objc func refreshCurrentPrice() {
    getCurrentPrice { price in
      guard price != nil else { return }
      guard let rate = price?.bpi["USD"]?.rate,
            let symbol = price?.bpi["USD"]?.symbol.htmlDecoded else { return }
      
      DispatchQueue.main.async {
        self.priceLabel?.text = "\(symbol)\(Double(truncating: (rate.currencyFormatter())).round(to: 2))"
      }
    }
  }
  
  
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension PriceListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()

    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    self.navigationController?.pushViewController(detailViewController, animated: true)

  }
  
  
}
