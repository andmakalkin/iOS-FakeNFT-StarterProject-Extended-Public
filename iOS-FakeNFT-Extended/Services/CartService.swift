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
    func payOrder(currencyId: String, nfts: [String]) async throws
}

final class CartService: CartServiceProtocol, @unchecked Sendable {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCart() async throws -> Order {
        try await networkClient.send(request: CartRequest())
    }
    
    func fetchNftById(id: String) async throws -> Nft {
        try await networkClient.send(request: NFTRequest(id: id))
    }
    
    func fetchCurrencies() async throws -> [Currency] {
        try await networkClient.send(request: CurrenciesRequest())
    }
    
    func deleteNftFromCart(id: String) async throws {
        let currentCart = try await fetchCart()
        let updatedNfts = currentCart.nfts.filter { $0 != id }
        
        let deleteRequest = CartDeleteRequest(nfts: updatedNfts)
        guard let urlRequest = deleteRequest.createURLRequest() else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkClientError.parsingError
        }
    }
    
    func payOrder(currencyId: String, nfts: [String]) async throws {
        let paymentRequest = OrderPaymentRequest(currencyId: currencyId)
        guard let urlPaymentRequest = paymentRequest.createURLRequest() else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }
        
        let (paymentData, paymentResponse) = try await URLSession.shared.data(for: urlPaymentRequest)
        guard let httpResponse = paymentResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkClientError.urlSessionError
        }
        
        struct PaymentResult: Codable { let success: Bool; let id: String }
        let paymentResult = try JSONDecoder().decode(PaymentResult.self, from: paymentData)
        guard paymentResult.success else {
            throw NetworkClientError.urlSessionError
        }
        
        let finalizeRequest = OrderFinalizeRequest(nfts: nfts)
        guard let urlFinalizeRequest = finalizeRequest.createURLRequest() else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }
        
        let (_, orderResponse) = try await URLSession.shared.data(for: urlFinalizeRequest)
        guard let httpOrderResponse = orderResponse as? HTTPURLResponse, (200...299).contains(httpOrderResponse.statusCode) else {
            throw NetworkClientError.urlSessionError
        }
        
        // Корзина автоматически не очищается после оплаты, поэтому делаем это принудительно
        let clearRequest = CartClearRequest()
        guard let urlClearRequest = clearRequest.createURLRequest() else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }
        
        let (_, clearResponse) = try await URLSession.shared.data(for: urlClearRequest)
        guard let httpClearResponse = clearResponse as? HTTPURLResponse, (200...299).contains(httpClearResponse.statusCode) else {
            throw NetworkClientError.urlSessionError
        }
    }
}
