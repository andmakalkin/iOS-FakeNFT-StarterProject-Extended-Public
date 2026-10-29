//
//  CartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import Foundation

protocol CartServiceProtocol: Sendable {
    func fetchCart() async throws -> Order
    func fetchNftById(id: String) async throws -> Nft
}

final class CartService: CartServiceProtocol, @unchecked Sendable {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCart() async throws -> Order {
        let request = CartRequest()
        return try await networkClient.send(request: request)
    }
    
    func fetchNftById(id: String) async throws -> Nft {
        let request = NFTRequest(id: id)
        return try await networkClient.send(request: request)
    }
}
