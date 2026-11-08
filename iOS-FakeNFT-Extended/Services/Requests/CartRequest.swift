//
//  CartRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import Foundation

struct CartRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get
    var dto: Encodable? = nil
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
