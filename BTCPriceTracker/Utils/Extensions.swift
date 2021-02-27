//
//  Extensions.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import Foundation

extension Double {

  func currencyFormatter(code: String) -> String {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.currencyCode = code
    formatter.numberStyle = .currency
    return formatter.string(from: self as NSNumber)!
  }
}

extension Date {
  func toString(_ format: String) -> String {
      
      let formatter: DateFormatter = DateFormatter()
      formatter.dateFormat = format
      
      return formatter.string(from: self)
  }
  
  func from(_ daysAgo: Int) -> Date {
    
    var dateComponents = DateComponents()
    dateComponents.day = -daysAgo
    return (Calendar.current as NSCalendar).date(byAdding: .day, value: -daysAgo, to: self, options: NSCalendar.Options(rawValue: 0))!
    
  }
}

extension String {
  func currencyFormatter () -> NSNumber {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .decimal
    
    return formatter.number(from: self) ?? 0
  }
}
extension URLSession {
  func dataTask( with url: URL, handler: @escaping (Result<Data, Error>) -> Void ) -> URLSessionDataTask {
    dataTask(with: url) { (data, _, error) in
      if let error = error {
        handler(.failure(error))
      } else {
        handler(.success(data ?? Data()))
      }
    }
  }
}
