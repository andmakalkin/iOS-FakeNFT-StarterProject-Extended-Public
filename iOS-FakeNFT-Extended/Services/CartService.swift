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
    func payOrder(nfts: [String]) async throws
    func clearCartOnServer() async throws
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
        
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1") else {
            throw NSError(domain: "CartService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неверный URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let bodyString = updatedNfts.map { "nfts=\($0)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "CartService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Не удалось удалить NFT на сервере"])
        }
    }
    
    func payOrder(nfts: [String]) async throws {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1") else {
            throw NSError(domain: "CartService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неверный URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let bodyString = nfts.map { "nfts=\($0)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "CartService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Ошибка при отправке платежа"])
        }
    }
    
    func clearCartOnServer() async throws {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1") else {
            throw NSError(domain: "CartService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неверный URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        request.httpBody = "".data(using: .utf8)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "CartService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Не удалось очистить корзину на сервере"])
        }
    }
}
