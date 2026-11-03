//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel(cartService: MockCartService())
    
    @State private var isSortSheetPresented = false
    @State private var isDeleteOverlayPresented = false
    @State private var nftModelToDelete: Nft? = nil
    
    @State private var deleteOverlayImageString = ""
    @State private var deleteOverlayId = ""
    
    @State private var isPaymentActive = false
    @State private var isSuccessActive = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.ypWhite.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button(action: {
                            isSortSheetPresented = true
                        }) {
                            Image(.sort42)
                                .resizable()
                                .frame(width: 42, height: 42)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    ZStack {
                        List {
                            ForEach(viewModel.cartNfts) { nft in
                                CartItemCell(nft: nft) {
                                    self.deleteOverlayId = nft.id
                                    self.deleteOverlayImageString = nft.images.first?.absoluteString ?? ""
                                    self.nftModelToDelete = nft
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        self.isDeleteOverlayPresented = true
                                    }
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.ypWhite)
                                .padding(.bottom, 8)
                            }
                        }
                        .listStyle(.plain)
                        .background(Color.ypWhite)
                        .scrollContentBackground(.hidden)
                        
                        if viewModel.state.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .ypBlack))
                                .scaleEffect(1.5)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.ypWhite.opacity(0.4))
                        }
                        
                        if viewModel.state.isEmpty {
                            EmptyCartView()
                                .frame(maxHeight: .infinity)
                                .background(Color.ypWhite)
                        }
                    }
                    
                    VStack(spacing: 0) {
                        Divider()
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(viewModel.totalCount) NFT")
                                    .font(AppFont.regular15)
                                    .foregroundColor(Color.ypBlack)
                                
                                Text(viewModel.totalPrice.ethFormatted)
                                    .font(AppFont.bold17)
                                    .foregroundColor(Color.ypUniversalGreen)
                                    .lineLimit(1)
                            }
                            Spacer()
                            
                            Button {
                                isPaymentActive = true
                            } label: {
                                Text("К оплате")
                                    .font(AppFont.bold17)
                                    .foregroundColor(Color.ypWhite)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Color.ypBlack)
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }
                    .background(Color.ypLightGrey)
                }
            }
            .background(Color.ypWhite)
            .navigationBarTitle("")
        }
        .onAppear {
            viewModel.loadCartData()
        }
        .fullScreenCover(isPresented: $isPaymentActive) {
            PaymentMethodView(cartService: viewModel.cartService) {
                isPaymentActive = false
            } onPaySuccess: {
                isPaymentActive = false
                isSuccessActive = true
            }
        }
        .fullScreenCover(isPresented: $isSuccessActive) {
            PaymentSuccessView {
                isSuccessActive = false 
            }
        }
        .fullScreenCover(isPresented: $isDeleteOverlayPresented) {
            CartDeleteConfirmationView(
                imageString: deleteOverlayImageString,
                isPresented: $isDeleteOverlayPresented,
                onDeleteAction: {
                    viewModel.deleteNft(id: deleteOverlayId)
                }
            )
            .presentationBackground(.clear)
        }
        .confirmationDialog("Сортировка", isPresented: $isSortSheetPresented, titleVisibility: .visible) {
            Button("По цене") { viewModel.currentSortOption = .price }
            Button("По рейтингу") { viewModel.currentSortOption = .rating }
            Button("По названию") { viewModel.currentSortOption = .name }
            Button("Закрыть", role: .cancel) { }
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
