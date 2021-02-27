//
//  DetaillViewModel.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import Foundation


class DetaillViewModel {
  
  var currencies: [String:String] = ["EUR": "€", "USD": "$", "GBP": "£"]
  var btcPrices = [String]()
  var day: String? = nil {
    didSet {
      get()
    }
  }
  var didUpdate: (()->())? = nil

  func get() {
    _ = currencies.map { currencyCode, currencySymbol in
      CoinDeskService.get(CoinDeskRequest.historicalClose(currency: currencyCode, start: day, end: day), type: HistoricalClose.self) { [weak self] (data, error) in
        guard error == nil else { return }
  
        if let price = data?.bpi.map({ $0.value})[0] {

          self?.btcPrices.append("\(currencySymbol)\(price.round(to: 2))")
          
          if let cCount = self?.currencies.count, let bCount = self?.btcPrices.count {
            if cCount == bCount {
              self?.didUpdate?()
            }
          }
        }
      }
    }
  }
}
