//
//  PaymentViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import Foundation
import Observation

enum PaymentState {
    case loading
    case content([Currency])
    case empty
    case error(String)
}

@Observable
final class PaymentViewModel {
    var state: PaymentState = .loading
    var selectedCurrencyId: String? = nil
    var showErrorAlert = false
    var errorMessage = ""
    
    var isPaymentProcessing = false
    
    let cartService: CartServiceProtocol
    
    init(cartService: CartServiceProtocol) {
        self.cartService = cartService
    }
    
    @MainActor
    func loadCurrencies() {
        state = .loading
        
        Task {
            do {
                let currencies = try await cartService.fetchCurrencies()
                if currencies.isEmpty {
                    state = .empty
                } else {
                    state = .content(currencies)
                }
            } catch {
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
                state = .error(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func pay(onSuccess: @escaping () -> Void) {
        guard selectedCurrencyId != nil else { return }
        
        isPaymentProcessing = true
        
        Task {
            do {
                let currentOrder = try await cartService.fetchCart()
                
                guard !currentOrder.nfts.isEmpty else {
                    throw NSError(domain: "PaymentError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Корзина пуста"])
                }
                
                try await cartService.payOrder(nfts: currentOrder.nfts)
                
                try await cartService.clearCartOnServer()
                
                isPaymentProcessing = false
                onSuccess()
                
            } catch {
                isPaymentProcessing = false
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
            }
        }
    }
}
