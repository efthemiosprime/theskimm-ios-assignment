//
//  Config.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import Foundation


struct Config {
  private init() {}
  static let RefreshRate: TimeInterval = 60.0
  static let TwoWeeksAgo: Int = 14
  static let HistoricalCloseDateFormat = "yyyy-MM-dd"
}
