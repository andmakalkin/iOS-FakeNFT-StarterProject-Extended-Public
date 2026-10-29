//
//  CartRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import Foundation

struct CartRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "/api/v1/orders/1") 
    }
}
