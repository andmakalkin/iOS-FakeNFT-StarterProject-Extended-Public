//
//  PaymentViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//

import Foundation
import Combine

enum PaymentViewState {
    case loading
    case content([Currency])
    case empty
    case error(String)
}

@MainActor
final class PaymentViewModel: ObservableObject {
    @Published private(set) var state: PaymentViewState = .loading
    @Published var selectedCurrencyId: String? = nil
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    private let cartService: CartServiceProtocol
    
    init(cartService: CartServiceProtocol) {
        self.cartService = cartService
    }
    
    func loadCurrencies() {
        state = .loading
        
        let _ = Task {
            do {
                let loadedCurrencies = try await cartService.fetchCurrencies()
                if loadedCurrencies.isEmpty {
                    state = .empty
                } else {
                    state = .content(loadedCurrencies)
                }
            } catch {
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
                state = .error(error.localizedDescription)
            }
        }
    }
}
