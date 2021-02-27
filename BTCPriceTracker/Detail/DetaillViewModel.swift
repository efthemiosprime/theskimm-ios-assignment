//
//  DetaillViewModel.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import Foundation


class DetaillViewModel {
  
  var currencies: [Config.Currency] = [Config.Currency.EUR, Config.Currency.USD, Config.Currency.GBP]
  var btcPrices = [String]()
  var day: String? = nil {
    didSet {
      get()
    }
  }
  var didUpdate: (()->())? = nil

  func get() {
    currencies.enumerated().forEach({(index, item) in
      CoinDeskService.get(CoinDeskRequest.historicalClose(currency: item.rawValue, start: day, end: day), type: HistoricalClose.self) { [weak self] (data, error) in
        guard error == nil else { return }
  
        if let price = data?.bpi.map({ $0.value}).first {
          self?.btcPrices.append("\(price.currencyFormatter(code: item.rawValue))")
          
          if let currenciesCount = self?.currencies.count, let btcPricesCount = self?.btcPrices.count {
            if currenciesCount == btcPricesCount {
              self?.didUpdate?()
            }
          }
        }
      }
    })
  }
}
