//
//  LastPrice.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/26/21.
//

import CoreData

@objc public class LastPrice: NSManagedObject {}

extension LastPrice {
  @NSManaged var rate: String
}
