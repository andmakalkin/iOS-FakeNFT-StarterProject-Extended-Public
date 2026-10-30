//
//  CollectionByIdRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 30.10.2026.
//

import Foundation

struct CollectionByIdRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)")
    }
}
