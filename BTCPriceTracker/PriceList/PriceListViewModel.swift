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
      DispatchQueue.main.async {
        RealmService.shared.deleteAllHistoricalValueCache()
      }
      historicalCloseValue?.bpi.forEach({ (key, value) in
        let historicalCloseValueCache = HistoricalValueCache(day: key, rate: value)
        DispatchQueue.main.async {
          RealmService.shared.create(historicalCloseValueCache)
        }
      })
    }
  }
  
  var currentValue: String? = nil {
    didSet {
      if let currentValue = currentValue {
        let currentValueCache = CurrentValueCache(rate: currentValue)
        DispatchQueue.main.async {
          RealmService.shared.create(currentValueCache, modified: true)
        }
      }
      self.didUpdateCurrentValue?()
      
    }
  }
  
  var pollingTimer: Timer?
  var didUpdateCurrentValue: (()->())? = nil
  var didUpateHistoricalValue: (( [String: Double]?)->())? = nil
  
  //MARK:- Coindesk
  func getCurrentPrice(_ completion: @escaping (CurrentPrice?) -> ()) {
    
    let service = CoinDeskService()
    service.get(CoinDeskRequest.currentPrice, type: CurrentPrice.self) { (data, error) in
      guard error == nil else { return }
      completion(data)
    }
  }
  
  
  func getHistoricalCloseData(_ completion: @escaping (HistoricalClose?) -> ()) {
    
    let startDate = Date().from(Config.TwoWeeksAgo).toString(Config.HistoricalCloseDateFormat)
    let endDate = Date().toString(Config.HistoricalCloseDateFormat)
    
    guard startDate <= endDate else { return }

    let request = CoinDeskRequest.historicalClose(currency: Config.Currency.EUR.rawValue, start: startDate, end: endDate)
    let service = CoinDeskService()
    service.get(request, type: HistoricalClose.self) { (data, error) in
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
      guard let rate = price?.bpi[Config.Currency.EUR.rawValue]?.rate else { return }
      self?.currentValue = "\(Double(truncating: (rate.currencyFormatter())).currencyFormatter(code: Config.Currency.EUR.rawValue))"
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
