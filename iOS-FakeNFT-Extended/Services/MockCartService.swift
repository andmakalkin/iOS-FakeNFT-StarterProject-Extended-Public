//
//  MockCartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import Foundation

// MARK: - МОКОВЫЙ СЕРВИС
final class MockCartService: CartServiceProtocol, @unchecked Sendable {
    
    private var currentOrderNfts = ["1", "2"]
    
    func fetchCart() async throws -> Order {
        try await Task.sleep(nanoseconds: 600_000_000)
        return Order(id: "cart_order_practicum", nfts: currentOrderNfts)
    }
    
    func fetchNftById(id: String) async throws -> Nft {
        try await Task.sleep(nanoseconds: 300_000_000)
        
        guard let url1 = URL(string: "nft1"),
              let url2 = URL(string: "nft2") else {
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: String(localized: .mockInvalidURLError)])
        }
        
        let mockNfts = [
            "1": Nft(id: "1", images: [url1], name: "May", rating: 5, price: 1.45, createdAt: "2026-10-01T21:00:00Z", description: "Nft1",  author: "Practicum", website: ""),
            "2": Nft(id: "2", images: [url2], name: "April", rating: 4, price: 3.20, createdAt: "2026-10-01T21:00:00Z", description: "Nft2", author: "Practicum", website: "")
        ]
        
        if let nft = mockNfts[id] {
            return nft
        } else {
            throw NSError(domain: "HTTPError", code: 404, userInfo: [NSLocalizedDescriptionKey: String(localized: .mockNFTNotFound)])
        }
    }
    
    func fetchCurrencies() async throws -> [Currency] {
        try await Task.sleep(nanoseconds: 200_000_000)
        
        let mockData = [
            ("Bitcoin", "BTC", "criptoBitcoin32"),
            ("Dogecoin", "DOGE", "criptoDogecoin32"),
            ("Ethereum", "ETH", "criptoEthereum32"),
            ("Cardano", "ADA", "criptoCardano32"),
            ("Ripple", "XRP", "criptoApeCoin32"),
            ("Solana", "SOL", "criptoSolana32"),
            ("Tether", "USDT", "criptoTether32"),
            ("Shiba Inu", "SHIB", "criptoShibaInu32")
        ]
        
        return mockData.compactMap { title, name, id in
            guard let url = URL(string: "https://stub") else { return nil }
            return Currency(title: title, name: name, image: url, id: id)
        }
    }
    
    func deleteNftFromCart(id: String) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        currentOrderNfts.removeAll { $0 == id }
    }
    
    func clearCart() async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
        currentOrderNfts = []
    }

    func payOrder(currencyId: String, nfts: [String]) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)
    }
    
}
