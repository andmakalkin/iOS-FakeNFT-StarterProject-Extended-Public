//
//  OrderFinalizeRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import Foundation

struct OrderFinalizeRequest {
    let nfts: [String]
    
    func createURLRequest() -> URLRequest? {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let bodyString = nfts.map { "nfts=\($0)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        return request
    }
}
