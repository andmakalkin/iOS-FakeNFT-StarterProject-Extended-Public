//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import Foundation
import Combine

extension CartViewModel {
    enum CartViewState {
        case loading
        case empty
        case content
        case error(String)
    }
}

@MainActor
final class CartViewModel: ObservableObject {
    @Published var state: CartViewState = .loading
    @Published var cartNfts: [Nft] = []
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private let cartService: CartServiceProtocol
    
    var totalPrice: Double { cartNfts.reduce(0) { $0 + $1.price } }
    var totalCount: Int { cartNfts.count }
    
    init(cartService: CartServiceProtocol) {
        self.cartService = cartService
    }
    
    func loadCartData() {
        state = .loading
        
        Task {
            do {
                let order = try await cartService.fetchCart()
                if order.nfts.isEmpty {
                    self.state = .empty
                } else {
                    try await self.loadNfts(ids: order.nfts)
                }
            } catch {
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
                self.state = .error(error.localizedDescription)
            }
        }
    }
    
    private func loadNfts(ids: [String]) async throws {
        var loadedNfts: [Nft] = []
        for id in ids {
            let nft = try await cartService.fetchNftById(id: id)
            loadedNfts.append(nft)
        }
        self.cartNfts = loadedNfts
        self.state = loadedNfts.isEmpty ? .empty : .content
    }
}
