//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import SwiftUI

struct CartView: View {
    
    // ВРЕМЕННО: Используем MockCartService, так как API сервера на данный момент недоступен.
    @StateObject private var viewModel = CartViewModel(
        cartService: MockCartService()
    )
    
    /*Раскомментировать, когда API сервера восстановит работу:
     @StateObject private var viewModel = CartViewModel(
     cartService: CartService(networkClient: DefaultNetworkClient())
     )
     */
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack(spacing: 0) {
                    List {
                        ForEach(viewModel.cartNfts) { nft in
                            CartItemCell(nft: nft)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.ypWhite)
                                .padding(.bottom, 8)
                        }
                    }
                    .listStyle(.plain)
                    .background(Color.ypWhite)
                    .scrollContentBackground(.hidden)
                    
                    CartFooterView(count: viewModel.totalCount, price: viewModel.totalPrice) {
                        print("Нажали к оплате")
                    }
                }
                
                if case .loading = viewModel.state {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .ypBlack))
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                
                
                if case .empty = viewModel.state {
                    EmptyCartView()
                        .frame(maxHeight: .infinity)
                        .background(Color.ypWhite)
                }
                
            }
            .background(Color.ypWhite)
            .navigationBarTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Нажали на кнопку сортировки")
                    }) {
                        Image(.sort42)
                            .resizable()
                            .frame(width: 42, height: 42)
                    }
                    .buttonStyle(.plain)
                    .background(Color.clear)
                }
            }
            .onAppear {
                viewModel.loadCartData()
            }
            .alert("Ошибка загрузки", isPresented: $viewModel.showErrorAlert) {
                Button("Ок", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        Text("Корзина пуста")
            .font(AppFont.bold17)
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}


