//
//  BTCPriceTrackerTests.swift
//  BTCPriceTrackerTests
//
//  Created by Bong Suyat on 2/26/21.
//

import XCTest
@testable import BTCPriceTracker

class BTCPriceTrackerTests: XCTestCase {

  func testCurrentPrice() {
    let expectation: XCTestExpectation = self.expectation(description: "Current Price Expectation")

    CoinDeskService.get(CoinDeskRequest.currentPrice, type: CurrentPrice.self) { price, error in
      XCTAssertNil(error, "Error \(String(describing: error?.localizedDescription))")
      XCTAssertNotNil(price, "Current price is empty")
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 5.0, handler:nil)

  }
  
  func testHistoricalCloseData() {
    let expectation: XCTestExpectation = self.expectation(description: "HistoricalClose Data Expectation")

    CoinDeskService.get(CoinDeskRequest.historicalClose(currency: "USD", start: "2021-02-11", end: "2021-02-25"), type: HistoricalClose.self) { (data, error) in
      XCTAssertNil(error, "Invalid Request")
      XCTAssertNotNil(data, "HistoricalClose data is empty")
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 5.0, handler:nil)

  }
  
  func testDetailViewModelGetFormattedPrice() {
    let detalViewModel = DetaillViewModel()
    XCTAssertEqual(detalViewModel.getFormattedPrice(data: nil, code: ""), "", "is empty")
    XCTAssertEqual(detalViewModel.getFormattedPrice(data: nil, code: ""), "", "is empty")

  }

}
