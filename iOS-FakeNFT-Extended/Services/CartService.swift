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
    func fetchCurrencies() async throws -> [Currency]
    func deleteNftFromCart(id: String) async throws
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
    
    func fetchCurrencies() async throws -> [Currency] {
        let request = CurrenciesRequest()
        return try await networkClient.send(request: request)
    }
    
    func deleteNftFromCart(id: String) async throws {
        let currentOrder = try await fetchCart()
        let updatedNfts = currentOrder.nfts.filter { $0 != id }
        let updatedOrder = Order(nfts: updatedNfts, id: currentOrder.id)
        let updateRequest = CartRequest(
            httpMethod: .put,
            dto: updatedOrder
        )
        _ = try await networkClient.send(request: updateRequest)
    }
    
}

