//
//  OrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(
            string: "\(RequestConstants.baseURL)/api/v1/orders/1"
        )
    }
}
