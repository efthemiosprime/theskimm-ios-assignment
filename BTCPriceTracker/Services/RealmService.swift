//
//  RealmService.swift
//  BTCPriceTracker
//
//  Created by Bong Suyat on 2/27/21.
//

import Foundation
import RealmSwift

class RealmService {
  private init() {}
  static let shared = RealmService()
  
  let realm = try! Realm()
  
  func create<T: Object>(_ object: T, modified: Bool = false) {
    do {
      try realm.write({
        if modified {
          realm.add(object, update: .modified)
        } else {
          realm.add(object)

        }
      })
    } catch {
      print("error \(error.localizedDescription)")
    }
  }
  
  func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
    do {
      try realm.write {
        for (key, value) in dictionary {
          object.setValue(value, forKey: key)
        }
      }
    } catch {
      print("error \(error.localizedDescription)")
    }
  }
  
  func delete<T: Object>(_ object: T) {
    do {
      try realm.write {
        realm.delete(object)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func deleteAllHistoricalValueCache() {
    do {
      try realm.write {
        realm.delete(realm.objects(HistoricalValueCache.self))
      }
    } catch {
      print(error.localizedDescription)
    }
  }

}
