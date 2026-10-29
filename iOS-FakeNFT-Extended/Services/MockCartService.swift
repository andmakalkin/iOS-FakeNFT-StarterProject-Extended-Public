//
//  MockCartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import Foundation

// MARK: - МОКОВЫЙ СЕРВИС
final class MockCartService: CartServiceProtocol, @unchecked Sendable {
    
    func fetchCart() async throws -> Order {
        try await Task.sleep(nanoseconds: 600_000_000)
        return Order(nfts: ["1", "2"], id: "cart_order_practicum")
    }
    
    func fetchNftById(id: String) async throws -> Nft {
        try await Task.sleep(nanoseconds: 300_000_000)
        
        guard let url1 = URL(string: "nft1"),
              let url2 = URL(string: "nft2") else {
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось создать URL для моков"])
        }
        
        let mockNfts = [
            "1": Nft(createdAt: "2026-10-01T21:00:00Z", name: "April", images: [url1], rating: 5, description: "Nft1", price: 1.45, author: "Practicum", website: "", id: "1"),
            "2": Nft(createdAt: "2026-10-01T21:00:00Z", name: "May", images: [url2], rating: 4, description: "Nft2", price: 3.20, author: "Practicum", website: "", id: "2")
        ]
        
        if let nft = mockNfts[id] {
            return nft
        } else {
            throw NSError(domain: "HTTPError", code: 404, userInfo: [NSLocalizedDescriptionKey: "NFT не найден"])
        }
    }
}
