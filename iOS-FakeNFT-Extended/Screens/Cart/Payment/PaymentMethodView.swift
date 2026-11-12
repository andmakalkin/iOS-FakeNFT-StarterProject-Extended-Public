//
//  PaymentMethodView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//

import SwiftUI

struct PaymentMethodView: View {
    @State private var viewModel: PaymentViewModel
    
    var onBackAction: () -> Void
    var onPaySuccess: () -> Void
    
    init(cartService: CartServiceProtocol, onBackAction: @escaping () -> Void, onPaySuccess: @escaping () -> Void) {
        _viewModel = State(wrappedValue: PaymentViewModel(cartService: cartService))
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
                            .foregroundStyle(.ypBlack)
                            .font(.system(size: 17, weight: .regular))
                    }
                    Spacer()
                    Text(.paymentSelectMethod)
                        .font(AppFont.bold17)
                        .foregroundStyle(.ypBlack)
                    Spacer()
                    Image(systemName: "chevron.backward").opacity(0)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.ypWhite)
                
                ZStack {
                    Color.ypWhite.ignoresSafeArea()
                    
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
                                    let isSelected = currency.id == viewModel.selectedCurrencyId
                                    
                                    Button {
                                        viewModel.selectedCurrencyId = currency.id
                                    } label: {
                                        CryptoCurrencyCell(
                                            currency: currency,
                                            isSelected: isSelected
                                        )
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel(currency.title)
                                    .accessibilityAddTraits(.isButton)
                                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                        }
                        
                    case .empty:
                        Text(.paymentNoCurrencies)
                            .font(AppFont.bold17)
                            .foregroundStyle(.ypBlack)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    case .error:
                        Color.clear
                    }
                }
                .onAppear {
                    viewModel.loadCurrencies()
                }
            }
            .background(Color.ypWhite)
            .navigationBarHidden(true)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(.paymentTermsIntro)
                            .font(AppFont.regular13)
                            .foregroundStyle(.ypBlack)
                        
                        if let termsUrl = URL(string: "https://yandex.ru/legal/practicum_termsofuse") {
                            NavigationLink {
                                WebView(url: termsUrl, title: String(localized: .paymentTermsTitle))
                            } label: {
                                Text(.paymentTermsLink)
                                    .font(AppFont.regular13)
                                    .foregroundStyle(.ypUniversalBlue)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    Button {
                        viewModel.pay {
                            
                            onPaySuccess()
                        }
                    } label: {
                        ZStack {
                            if viewModel.isPaymentProcessing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .ypWhite))
                            } else {
                                Text(.paymentPay)
                                    .font(AppFont.bold17)
                                    .foregroundStyle(.ypWhite)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(.ypBlack)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .disabled(viewModel.selectedCurrencyId == nil || viewModel.isPaymentProcessing)
                    .opacity((viewModel.selectedCurrencyId == nil || viewModel.isPaymentProcessing) ? 0.5 : 1.0)
                }
                .background {
                    UnevenRoundedRectangle(
                        topLeadingRadius: 12,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 12
                    )
                    .fill(Color.ypLightGrey)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .alert(String(localized: .paymentFailed), isPresented: $viewModel.showErrorAlert) {
                Button(String(localized: .commonCancel), role: .cancel) { }
                Button(String(localized: .commonRetry)) {
                    if case .error = viewModel.state {
                        viewModel.loadCurrencies()
                    } else {
                        viewModel.pay { onPaySuccess() }
                    }
                }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
        .navigationViewStyle(.stack)
    }
}
