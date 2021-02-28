//
//  RealmModels.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/27/21.
//

import RealmSwift
import Foundation

class CurrentValueCache: Object {
  @objc dynamic var id = "currentValue"
  @objc dynamic var rate: String = ""
  convenience init (rate: String) {
    self.init()
    self.rate = rate
  }
  
  override static func primaryKey() -> String? {
     return "id"
   }
  
}



class HistoricalValueCache: Object {
  @objc dynamic var day: String = ""
  @objc dynamic var rate: Double = 0.0

  convenience init (day: String, rate: Double) {
    self.init()
    self.day = day
    self.rate = rate
  }
}
