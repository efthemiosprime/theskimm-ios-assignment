//
//  CoinDeskAPI.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import Foundation

enum CoinDeskRequest {
  case currentPrice
  case historicalClose(currency: String? = "USD", start: String?, end: String?)
}


extension CoinDeskRequest {
  var url: URL {
    switch self {
    case .currentPrice:
      return URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
    case let .historicalClose(currency, start, end):
      var components = URLComponents()
      components.scheme = "https"
      components.host = "api.coindesk.com"
      components.path = "/v1/bpi/historical/close.json"
      var items: [URLQueryItem] = []
      if let currency = currency {
        items.append(URLQueryItem(name: "currency", value: currency))
      }
      
      if let start = start, let end = end {
        items.append(URLQueryItem(name: "start", value: start))
        items.append(URLQueryItem(name: "end", value: end))
      }
      
      components.queryItems = items
      return components.url!
    }
  }
}


struct CoinDeskService {
}
