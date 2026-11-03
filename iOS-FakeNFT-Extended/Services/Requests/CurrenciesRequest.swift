//
//  CurrenciesRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "/api/v1/currencies")
    }
}
