//
//  Extensions.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import Foundation

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
