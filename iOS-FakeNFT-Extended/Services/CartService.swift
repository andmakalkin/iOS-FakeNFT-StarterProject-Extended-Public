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
    func clearCart() async throws
    func payOrder(currencyId: String, nfts: [String]) async throws
}

final class CartService: CartServiceProtocol, @unchecked Sendable {
    private let networkClient: NetworkClient
    private let orderService: OrderServiceProtocol

    init(networkClient: NetworkClient, orderService: OrderServiceProtocol) {
        self.networkClient = networkClient
        self.orderService = orderService
    }

    func fetchCart() async throws -> Order {
        try await orderService.loadOrder()
    }

    func fetchNftById(id: String) async throws -> Nft {
        try await networkClient.send(request: NFTRequest(id: id))
    }

    func fetchCurrencies() async throws -> [Currency] {
        try await networkClient.send(request: CurrenciesRequest())
    }

    func deleteNftFromCart(id: String) async throws {
        _ = try await orderService.removeNft(nftId: id)
    }

    func clearCart() async throws {
        _ = try await orderService.clearOrder()
    }

    func payOrder(currencyId: String, nfts: [String]) async throws {
        let paymentRequest = OrderPaymentRequest(currencyId: currencyId)
        guard let urlPaymentRequest = paymentRequest.createURLRequest() else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }

        let (paymentData, paymentResponse) = try await URLSession.shared.data(for: urlPaymentRequest)
        guard let httpResponse = paymentResponse as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
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
        guard let httpOrderResponse = orderResponse as? HTTPURLResponse,
              (200...299).contains(httpOrderResponse.statusCode) else {
            throw NetworkClientError.urlSessionError
        }

        try await clearCart()
    }
}
