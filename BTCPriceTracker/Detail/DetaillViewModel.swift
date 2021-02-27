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
      let service = CoinDeskService()
      service.get(CoinDeskRequest.historicalClose(currency: item.rawValue, start: day, end: day), type: HistoricalClose.self) { [weak self] (data, error) in
        guard error == nil else { return }
  
        if let price = self?.getFormattedPrice(data: data, code: item.rawValue) {
          self?.btcPrices.append(price)
          if let currenciesCount = self?.currencies.count, let btcPricesCount = self?.btcPrices.count {
            if currenciesCount == btcPricesCount {
              self?.didUpdate?()
            }
          }
        }

      }
    })
  }
  
  func getFormattedPrice(data: HistoricalClose?, code: String) -> String {
    guard let price = data?.bpi.map({ $0.value}).first else { return "" }
    let formattedPrice = price.currencyFormatter(code: code)
    
    return formattedPrice
  }
}
