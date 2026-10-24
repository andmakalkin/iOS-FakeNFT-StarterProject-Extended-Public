//
//  CollectionsRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 24.10.2026.
//

import Foundation

struct CollectionsRequest: NetworkRequest {
    let page: Int
    let size: Int
    let sortBy: String

    var endpoint: URL? {
        guard var components = URLComponents(
            string: "\(RequestConstants.baseURL)/api/v1/collections"
        ) else {
            return nil
        }

        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(size)),
            URLQueryItem(name: "sortBy", value: sortBy)
        ]

        return components.url
    }
}

