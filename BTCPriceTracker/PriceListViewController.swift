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
  
  var pollingTimer: Timer?
  var historicalCloseData: [String: Double]?
  var historicalCloseDataKeys: [String]?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    refreshCurrentPrice()
    refreshHistoricalCloseData()
    startPollingTimer()
  }
    
  //MARK:- Setup
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  
  //MARK:- Coindesk
  func getCurrentPrice(_ completion: @escaping (CurrentPrice?) -> ()) {

    CoinDeskService.get(CoinDeskRequest.currentPrice, type: CurrentPrice.self) { (data, error) in
      guard error == nil else { return }
      completion(data ?? nil)
    }
  }
  
  func getHistoricalCloseData(_ completion: @escaping (HistoricalClose?) -> ()) {
    
    let startDate = getDateFrom(daysAgo: Config.TwoWeeksAgo).format("yyyy-MM-dd")
    let endDate = Date().format("yyyy-MM-dd")

    let request = CoinDeskRequest.historicalClose(currency: "USD", start: startDate, end: endDate)
    CoinDeskService.get(request, type: HistoricalClose.self) { (data, error) in
      completion(data)
    }

  }
  
  //MARK:- Refresh view
  @objc func refreshCurrentPrice() {
    getCurrentPrice { price in
      guard price != nil else { return }
      guard let rate = price?.bpi["USD"]?.rate,
            let symbol = price?.bpi["USD"]?.symbol.htmlDecoded else { return }
      
      DispatchQueue.main.async { [weak self] in
        self?.priceLabel?.text = "\(symbol)\(Double(truncating: (rate.currencyFormatter())).round(to: 2))"
      }
    }
  }
  
  func refreshHistoricalCloseData() {
    getHistoricalCloseData { data in
      guard data != nil else { return }
      DispatchQueue.main.async { [weak self] in
        self?.historicalCloseData = data?.bpi
        if let keys = self?.historicalCloseData?.keys {
          self?.historicalCloseDataKeys = Array(keys).sorted{$0 > $1}
          self?.tableView.reloadData()
        }
      }
    }
  }
  
  func startPollingTimer() {
    pollingTimer?.invalidate()
    pollingTimer = Timer.scheduledTimer(timeInterval: Config.RefreshRate, target: self, selector: #selector(refreshCurrentPrice), userInfo: nil, repeats: true)

  }
  
}

//MARK:- Helpers
extension PriceListViewController {
  func getDateFrom(daysAgo: Int) -> Date {
    
    var dateComponents = DateComponents()
    dateComponents.day = -daysAgo
    return (Calendar.current as NSCalendar).date(byAdding: .day, value: -daysAgo, to: Date(), options: NSCalendar.Options(rawValue: 0))!
  }
  
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension PriceListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.historicalCloseData?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell

    let currentKey = historicalCloseDataKeys![indexPath.row]
    cell.textLabel?.text = "\(currentKey): $\(String(describing: historicalCloseData![currentKey]!.round(to: 2)) )"

    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    detailViewController.selectedDay = self.historicalCloseDataKeys![indexPath.row]
    self.navigationController?.pushViewController(detailViewController, animated: true)

  }
  
  
}
