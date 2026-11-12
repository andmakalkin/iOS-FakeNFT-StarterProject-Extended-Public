//
//  CurrenciesRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
