//
//  PaymentMethodView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//

import SwiftUI

struct PaymentMethodView: View {
    @State private var viewModel: PaymentViewModel
    @State private var isTermsActive = false
    
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
                    Text("Выберите способ оплаты")
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
                            .foregroundStyle(.ypBlack)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    case .error:
                        Color.clear
                    }
                }
                .onAppear {
                    viewModel.loadCurrencies() 
                }
                Spacer()
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Совершая покупку, вы соглашаетесь с условиями")
                            .font(AppFont.regular13)
                            .foregroundStyle(.ypBlack)
                        
                        if let termsUrl = URL(string: "https://yandex.ru") {
                            NavigationLink(
                                destination: TermsWebView(url: termsUrl, title: "Пользовательское соглашение"),
                                isActive: $isTermsActive
                            ) {
                                Text("Пользовательского соглашения")
                                    .font(AppFont.regular13)
                                    .foregroundStyle(.ypUniversalBlue)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    Button {
                        onPaySuccess()
                    } label: {
                        Text("Оплатить")
                            .font(AppFont.bold17)
                            .foregroundStyle(.ypWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(.ypBlack)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 20) 
                    .disabled(viewModel.selectedCurrencyId == nil)
                    .opacity(viewModel.selectedCurrencyId == nil ? 0.5 : 1.0)
                }
                .background(Color.ypLightGrey)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 12,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 12
                    )
                )

            }
            .background(Color.ypWhite)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

