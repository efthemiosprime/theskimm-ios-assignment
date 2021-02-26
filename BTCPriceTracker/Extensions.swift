//
//  Extensions.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import Foundation

extension Double {
  func round(to places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}

extension Date {
  func format(_ format: String) -> String {
      
      let formatter: DateFormatter = DateFormatter()
      formatter.dateFormat = format
      
      return formatter.string(from: self)
  }
}

extension String {
  func currencyFormatter () -> NSNumber {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .decimal
    
    return formatter.number(from: self) ?? 0
  }
  
  // https://stackoverflow.com/questions/40113805/decode-html-string
  var htmlDecoded: String {
      let decoded = try? NSAttributedString(
          data: Data(utf8),
          options: [.documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue],
          documentAttributes: nil).string

      return decoded ?? self
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
