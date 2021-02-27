# theskimm-ios-assignment
An example iPhone app that displays current and historical (2 weeks) exchange rates in EUR using Bitcoin Price Index API. 
The app was built using MVVM architecture. 
## Notes
I used Model View to consume endpoints with `CoinDeskService` and to notify View Controller using closures. In `PriceListViewModel`, the two closures are: `didUpateHistoricalValue` and `didUpdateCurrentValue`. `PriceListViewController` listens for these two closures to be triggered and then updates the UI. `PriceListViewModel` is also responsible for polling current BTC value every 60 seconds. This flow is also adapted in `DetailViewModel`.

* Services/CoinDeskAPI.swift
    * Request enumeration maps encodes and build URLS, convenient service for consuming endpoints

* PriceList/PriceListViewController.swift
    * Responsible for displaying current value and historical data 

* PriceList/PriceListViewModel.swift
    * Responsible for providing and updating data to `PriceListViewController`


* Detail/DetailViewController.swift
    * Responsible for displaying price for EUR, USD and GBP

* Detail/DetailViewModel.swift
    * Responsible for providing data for `DetailViewController`

* Models/Models.swift
    * Decodable structs that can help decode CoinDesk JSON response

* Utils/*
    * Utilities and extensions for formatting correct currency depending on currency code, getting date from days ago ... etc

## Requirements 
- iOS 14.0+ 
- Swift 5.0+

## Getting Started 
1. [Download](https://developer.apple.com/xcode/download/) the Version 12.4+ release.
1. Clone this repository.