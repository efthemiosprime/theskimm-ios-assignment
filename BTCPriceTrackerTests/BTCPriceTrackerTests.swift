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
    let service = CoinDeskService()
    service.get(CoinDeskRequest.currentPrice, type: CurrentPrice.self) { price, error in
      XCTAssertNil(error, "Invalid Request")
      XCTAssertNotNil(price, "Current price is empty")
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 5.0, handler:nil)

  }
  
  func testHistoricalCloseData() {
    let expectation: XCTestExpectation = self.expectation(description: "HistoricalClose Data Expectation")
    let service = CoinDeskService()
    service.get(CoinDeskRequest.historicalClose(currency: "USD", start: "2021-02-11", end: "2021-02-25"), type: HistoricalClose.self) { (data, error) in
      XCTAssertNil(error, "Invalid Request")
      XCTAssertNotNil(data, "HistoricalClose data is empty")
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 5.0, handler:nil)

  }
  
  func testDetailViewModelGetFormattedPrice() {
    let detalViewModel = DetaillViewModel()
    let mockData = HistoricalClose(bpi: ["2021-02-25": 38664.454], time: BTCPriceTracker.Time(updated: "Feb 26, 2021 00:03:00 UTC", updatedISO: Date().fromString("2021-02-26 00:03:00 +0000"), updateduk: nil))
    
    XCTAssertEqual(detalViewModel.getFormattedPrice(data: mockData, code: Config.Currency.USD.rawValue), "$38,664.45", "It's not USD")
    XCTAssertEqual(detalViewModel.getFormattedPrice(data: mockData, code: Config.Currency.EUR.rawValue), "€38,664.45", "It's not EUR")
    XCTAssertEqual(detalViewModel.getFormattedPrice(data: mockData, code: Config.Currency.GBP.rawValue), "£38,664.45", "It's not GBP")
    XCTAssertNotEqual(detalViewModel.getFormattedPrice(data: mockData, code: Config.Currency.GBP.rawValue), "", "Price is empty")
    //
    XCTAssertNotEqual(detalViewModel.getFormattedPrice(data: nil, code: ""), "", "Price is empty")

  }

}
