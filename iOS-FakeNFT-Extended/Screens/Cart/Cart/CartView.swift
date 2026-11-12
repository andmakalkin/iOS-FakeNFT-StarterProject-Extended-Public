//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//

import SwiftUI

struct CartView: View {
    @State private var viewModel: CartViewModel
    
    @State private var isSortSheetPresented = false
    @State private var isDeleteOverlayPresented = false
    @State private var nftModelToDelete: Nft? = nil
    
    @State private var deleteOverlayImageString = ""
    @State private var deleteOverlayId = ""
    
    @State private var isPaymentActive = false
    @State private var isSuccessActive = false

    init(cartService: CartServiceProtocol) {
        _viewModel = State(wrappedValue: CartViewModel(cartService: cartService))
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.ypWhite.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if !viewModel.cartNfts.isEmpty && !viewModel.state.isEmpty {
                        HStack {
                            Spacer()
                            Button(action: {
                                isSortSheetPresented = true
                            }) {
                                Image(.sort42)
                                    .renderingMode(.template)
                                    .resizable()
                                    .foregroundStyle(.ypBlack)
                                    .frame(width: 42, height: 42)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                    
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
                                .listRowInsets(EdgeInsets(.zero))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.ypWhite)
                                .padding(.bottom, 8)
                            }
                        }
                        .listStyle(.plain)
                        .background(.ypWhite)
                        .scrollContentBackground(.hidden)
                        
                        if viewModel.state.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .ypBlack))
                                .scaleEffect(1.5)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.ypWhite.opacity(0.4))
                        }
                        
                        if viewModel.state.isEmpty {
                            EmptyCartView()
                                .frame(maxHeight: .infinity)
                                .background(.ypWhite)
                        }
                    }
                    
                    if !viewModel.cartNfts.isEmpty && !viewModel.state.isEmpty && !viewModel.state.isLoading {
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(.cartNFTCount(count: viewModel.totalCount))
                                    .font(AppFont.regular15)
                                    .foregroundStyle(.ypBlack)
                                
                                Text(viewModel.totalPrice.ethFormatted)
                                    .font(AppFont.bold17)
                                    .foregroundStyle(.ypUniversalGreen)
                                    .lineLimit(1)
                            }
                            Spacer()
                            
                            Button {
                                isPaymentActive = true
                            } label: {
                                Text(.cartCheckout)
                                    .font(AppFont.bold17)
                                    .foregroundStyle(.ypWhite)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(.ypBlack)
                                    .cornerRadius(16)
                            }
                            .disabled(viewModel.cartNfts.isEmpty || viewModel.state.isLoading)
                            .opacity((viewModel.cartNfts.isEmpty || viewModel.state.isLoading) ? 0.5 : 1.0)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 12,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 12
                            )
                            .fill(.ypLightGrey)
                        )
                    }
                }
            }
            .background(.ypWhite)
            .navigationBarTitle("")
            .alert(String(localized: .cartLoadingError), isPresented: $viewModel.showErrorAlert) {
                Button(String(localized: .commonOK), role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            viewModel.loadCartData()
        }
        .fullScreenCover(isPresented: $isPaymentActive) {
                    PaymentMethodView(
                        cartService: viewModel.cartService,
                        onBackAction: {
                            isPaymentActive = false
                        },
                        onPaySuccess: {
                            isPaymentActive = false
                            isSuccessActive = true
                        }
                    )
                }
        .fullScreenCover(isPresented: $isSuccessActive) {
            PaymentSuccessView(cartViewModel: viewModel) {
                isSuccessActive = false
            }
        }
        
        .fullScreenCover(item: $nftModelToDelete) { nft in
            CartDeleteConfirmationView(
                imageString: nft.images.first?.absoluteString ?? "",
                isPresented: Binding(
                    get: { nftModelToDelete != nil },
                    set: { if !$0 { nftModelToDelete = nil } }
                ),
                onDeleteAction: {
                    let idToDelete = nft.id
                    nftModelToDelete = nil
                    viewModel.deleteNft(id: idToDelete)
                }
            )
            .presentationBackground(.clear)
        }
        .confirmationDialog(String(localized: .sortTitle), isPresented: $isSortSheetPresented, titleVisibility: .visible) {
            Button(String(localized: .sortByPrice)) { viewModel.currentSortOption = .price }
            Button(String(localized: .sortByRating)) { viewModel.currentSortOption = .rating }
            Button(String(localized: .sortByName)) { viewModel.currentSortOption = .name }
            Button(String(localized: .commonClose), role: .cancel) { }
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        Text(.cartEmpty)
            .font(AppFont.bold17)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
