//
//  OrderService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

protocol OrderServiceProtocol: Sendable {
    func loadOrder() async throws -> Order
    func updateOrder(nfts: [String]) async throws -> Order
}

actor OrderService: OrderServiceProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadOrder() async throws -> Order {
        let request = OrderRequest()

        return try await networkClient.send(request: request)
    }
    
    func updateOrder(nfts: [String]) async throws -> Order {
        let request = UpdateOrderRequest(nfts: nfts)
        
        return try await networkClient.send(request: request)
    }
}
