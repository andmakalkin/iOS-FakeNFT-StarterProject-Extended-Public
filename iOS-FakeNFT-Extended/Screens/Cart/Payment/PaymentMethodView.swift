//
//  PaymentMethodView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//

import SwiftUI

struct PaymentMethodView: View {
    @StateObject private var viewModel: PaymentViewModel
    @State private var isTermsActive = false
    
    var onBackAction: () -> Void
    var onPaySuccess: () -> Void
    
    init(cartService: CartServiceProtocol, onBackAction: @escaping () -> Void, onPaySuccess: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: PaymentViewModel(cartService: cartService))
        self.onBackAction = onBackAction
        self.onPaySuccess = onPaySuccess
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]
    
    var body: some View {
          NavigationView {
            VStack(spacing: 0) {
                 HStack {
                    Button {
                        onBackAction()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.ypBlack)
                            .font(.system(size: 17, weight: .regular))
                    }
                    Spacer()
                    Text("Выберите способ оплаты")
                        .font(AppFont.bold17)
                        .foregroundColor(.ypBlack)
                    Spacer()
                    Image(systemName: "chevron.backward").opacity(0)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                ZStack {
                    switch viewModel.state {
                    case .loading:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .ypBlack))
                            .scaleEffect(1.5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    case .content(let currencies):
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 7) {
                                ForEach(currencies) { currency in
                                    CryptoCurrencyCell(
                                        currency: currency,
                                        isSelected: currency.id == viewModel.selectedCurrencyId
                                    )
                                    .onTapGesture {
                                        viewModel.selectedCurrencyId = currency.id
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                        }
                        
                    case .empty:
                        Text("Нет доступных валют")
                            .font(AppFont.bold17)
                            .foregroundColor(.ypBlack)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    case .error:
                        Color.clear
                    }
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    VStack(spacing: 0) {
                        Text("Совершая покупку, вы соглашаетесь с условиями")
                            .font(AppFont.regular13)
                            .foregroundColor(Color.ypBlack)
                        
                        if let termsUrl = URL(string: "https://yandex.ru/legal/practicum_termsofuse") {
                            NavigationLink(
                                destination: TermsWebView(url: termsUrl, title: "Пользовательское соглашение"),
                                isActive: $isTermsActive
                            ) {
                                Text("Пользовательского соглашения")
                                    .font(AppFont.regular13)
                                    .foregroundColor(Color.ypUniversalBlue)
                            }
                        } else {
                            Text("Пользовательского соглашения")
                                .font(AppFont.regular13)
                                .foregroundColor(Color.ypLightGrey)
                        }
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    Button {
                        onPaySuccess()
                    } label: {
                        Text("Оплатить")
                            .font(AppFont.bold17)
                            .foregroundColor(.ypWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.ypBlack)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    .disabled(viewModel.selectedCurrencyId == nil)
                    .opacity(viewModel.selectedCurrencyId == nil ? 0.5 : 1.0)
                }
                .background(Color.ypLightGrey.cornerRadius(12))
            }
            .background(Color.ypWhite)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            viewModel.loadCurrencies()
        }
        .alert("Ошибка загрузки", isPresented: $viewModel.showErrorAlert) {
            Button("Ок") { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}
