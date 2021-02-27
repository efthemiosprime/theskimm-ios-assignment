## Architecture
1. The app was built using MVVM architecture.
2. Web services are encapsulated in the `CoinDeskService` type.
3. `PriceListViewModel` contains two closures that notify view controller: `didUpateHistoricalValue` and `didUpdateCurrentValue`
4. `PriceListViewController` listens for these two closures to be triggered, and then updates the UI.
5. `PriceListViewModel` is also responsible for polling current BTC value every 60 seconds. This flow is also adapted in 6. 6.6. `DetailViewModel`.



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