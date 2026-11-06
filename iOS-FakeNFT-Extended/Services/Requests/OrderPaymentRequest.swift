//
//  OrderPaymentRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import Foundation

struct OrderPaymentRequest {
    let currencyId: String
    
    func createURLRequest() -> URLRequest? {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        return request
    }
}
