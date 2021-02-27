//
//  CoinDeskAPI.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import Foundation

enum CoinDeskRequest {
  case currentPrice
  case historicalClose(currency: String? = Config.Currency.EUR.rawValue, start: String?, end: String?)
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

  static func get<T: Decodable>(_ request: CoinDeskRequest, type: T.Type, completionHandler: ((T?, Error?) -> Void)?) {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let task = URLSession.shared.dataTask(with: request.url) { result in
      switch result {
      case .success(let data):
        do {
          let data = try decoder.decode(T.self, from: data)
          completionHandler?(data, nil)
        } catch let error {
          print(error.localizedDescription)
        }
      case .failure(let error):
        completionHandler?(nil, error)
      }
    }
    
    task.resume()
  }
}


