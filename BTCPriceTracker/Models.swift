//
//  Models.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import Foundation

import Foundation

struct CurrentPrice: Decodable {
  let time: Time
  let chartName: String
  let bpi: [String: Price]
}

struct Time: Decodable {
  let updated: String
  let updatedISO: Date
  let updateduk: String?
}

struct Price: Decodable {
  let code: String
  let symbol: String
  let rate: String
  let rate_float: Double
}

struct HistoricalClose: Decodable {
  let bpi: [String: Double]
  let time: Time
}
