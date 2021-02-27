//
//  PriceListViewModel.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import Foundation

class PriceListViewModel {
  
  var historicalCloseValue: HistoricalClose? = nil {
    didSet {
      self.didUpateHistoricalValue?(historicalCloseValue?.bpi)
    }
  }
  var currentValue: String? = nil {
    didSet {
      self.didUpdateCurrentValue?()
    }
  }
  
  var pollingTimer: Timer?
  var didUpdateCurrentValue: (()->())? = nil
  var didUpateHistoricalValue: (( [String: Double]?)->())? = nil
  
  
  //MARK:- Coindesk
  func getCurrentPrice(_ completion: @escaping (CurrentPrice?) -> ()) {

    CoinDeskService.get(CoinDeskRequest.currentPrice, type: CurrentPrice.self) { (data, error) in
      guard error == nil else { return }
      completion(data)
    }
  }
  
  func getHistoricalCloseData(_ completion: @escaping (HistoricalClose?) -> ()) {
    
    let startDate = Date().from(Config.TwoWeeksAgo).toString(Config.HistoricalCloseDateFormat)
    let endDate = Date().toString(Config.HistoricalCloseDateFormat)
    
    guard startDate <= endDate else { return }

    let request = CoinDeskRequest.historicalClose(currency: "USD", start: startDate, end: endDate)
    CoinDeskService.get(request, type: HistoricalClose.self) { (data, error) in
      completion(data)
    }

  }
  
  func updateHistoricalCloseValue() {
    getHistoricalCloseData { [weak self] data in
      guard data != nil else { return }
      self?.historicalCloseValue = data
    }
  }
  
  @objc func updateCurrentValue() {
    getCurrentPrice { [weak self] price in
      guard let rate = price?.bpi[Config.Currency.USD.rawValue]?.rate else { return }
      self?.currentValue = "\(Double(truncating: (rate.currencyFormatter())).currencyFormatter(code: Config.Currency.USD.rawValue))"
    }
  }
  
  func startPolling(every: TimeInterval? = 10) {
    pollingTimer?.invalidate()
    pollingTimer = Timer.scheduledTimer(timeInterval: every ?? 10, target: self, selector: #selector(updateCurrentValue), userInfo: nil, repeats: true)
  }
  
  func stopPolling() {
    pollingTimer?.invalidate()
  }
}
