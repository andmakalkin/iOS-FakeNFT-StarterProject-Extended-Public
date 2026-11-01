//
//  UpdateOrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    let nfts: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var bodyParameters: [URLQueryItem]? {
        if nfts.isEmpty {
            return [
                URLQueryItem(name: "nfts", value: "")
            ]
        }

        return nfts.map {
            URLQueryItem(name: "nfts", value: $0)
        }
    }
}
