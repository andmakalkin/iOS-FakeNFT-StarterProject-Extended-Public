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

enum PaymentStep {
    case initial
    case paymentSent
    case orderFinalized
}

@Observable
final class PaymentViewModel {
    var state: PaymentState = .loading
    var selectedCurrencyId: String? = nil
    var showErrorAlert = false
    var errorMessage = ""
    var isPaymentProcessing = false
    
    private var currentStep: PaymentStep = .initial
    
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
        guard let currencyId = selectedCurrencyId else { return }
        isPaymentProcessing = true
        
        Task {
            do {
                let currentOrder = try await cartService.fetchCart()
                guard !currentOrder.nfts.isEmpty || currentStep != .initial else {
                    throw NSError(domain: "PaymentError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Корзина пуста"])
                }
                
                if currentStep == .initial {
                    let paymentRequest = OrderPaymentRequest(currencyId: currencyId)
                    guard let urlPaymentRequest = paymentRequest.createURLRequest() else { return }
                    
                    let (paymentData, paymentResponse) = try await URLSession.shared.data(for: urlPaymentRequest)
                    guard let httpResponse = paymentResponse as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        throw NSError(domain: "PaymentError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Ошибка при отправке платежа"])
                    }
                    
                    struct PaymentResult: Codable { let success: Bool; let id: String }
                    let paymentResult = try JSONDecoder().decode(PaymentResult.self, from: paymentData)
                    guard paymentResult.success else {
                        throw NSError(domain: "PaymentError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Платеж отклонен сервером"])
                    }
                    
                    currentStep = .paymentSent
                }
                
                if currentStep == .paymentSent {
                    let finalizeRequest = OrderFinalizeRequest(nfts: currentOrder.nfts)
                    guard let urlFinalizeRequest = finalizeRequest.createURLRequest() else { return }
                    
                    let (_, orderResponse) = try await URLSession.shared.data(for: urlFinalizeRequest)
                    guard let httpOrderResponse = orderResponse as? HTTPURLResponse, (200...299).contains(httpOrderResponse.statusCode) else {
                        throw NSError(domain: "PaymentError", code: -4, userInfo: [NSLocalizedDescriptionKey: "Ошибка при завершении заказа"])
                    }
                    
                    currentStep = .orderFinalized
                }
                
                if currentStep == .orderFinalized {
                    let clearRequest = CartClearRequest()
                    guard let urlClearRequest = clearRequest.createURLRequest() else { return }
                    
                    let (_, clearResponse) = try await URLSession.shared.data(for: urlClearRequest)
                    guard let httpClearResponse = clearResponse as? HTTPURLResponse, (200...299).contains(httpClearResponse.statusCode) else {
                        throw NSError(domain: "PaymentError", code: -5, userInfo: [NSLocalizedDescriptionKey: "Ошибка при принудительной очистке сервера"])
                    }
                }
                
                currentStep = .initial
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
