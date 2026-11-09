//
//  MyNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-01.
//

import SwiftUI

struct MyNFTView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel: MyNFTViewModel
    
    @State private var isFiltersShow = false
    
    let profile: Profile

    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(.backward24)
                                .renderingMode(.template)
                                .foregroundStyle(.ypBlack)
                                .frame(width: 24, height: 24)
                        }
                        Spacer()
                        Button {
                            isFiltersShow = true
                        } label: {
                            Image(.sort42)
                                .renderingMode(.template)
                                .foregroundStyle(.ypBlack)
                                .frame(width: 42, height: 42)
                        }

                    }
                    Text("Мои NFT")
                        .font(AppFont.bold17)
                        .foregroundStyle(.ypBlack)
                }
                .padding(EdgeInsets(top: 2, leading: 9, bottom: 9, trailing: 9))
                
                ScrollView {
                    LazyVStack(spacing: 32) {
                        ForEach(viewModel.filtredNFTs) { nft in
                            NFTCell(nft: nft) {
                                Task {
                                    await viewModel.toggleLike(nftId: nft.id)
                                }
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .scrollIndicators(.hidden)
                
                Spacer()
            }
            
            Text("У Вас ещё нет NFT")
                .font(AppFont.bold17)
                .foregroundStyle(.ypBlack)
                .opacity((viewModel.filtredNFTs.isEmpty && !viewModel.isLoading) ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .confirmationDialog("Сортировка", isPresented: $isFiltersShow, titleVisibility: .visible) {
            Button("По цене") {
                viewModel.currentFilter = .price
            }
            Button("По рейтингу") {
                viewModel.currentFilter = .rating
            }
            Button("По названию") {
                viewModel.currentFilter = .name
            }
        }
        .task {
            await viewModel.loadNfts(ids: profile.nfts)
        }
    }
}

#Preview {
    let profile = Profile(id: "1", name: "name", nfts: ["1","2"], likes: [], avatar: "https://i.pinimg.com/1200x/d3/49/1b/d3491b2125cd256caeb793aa8b9fa748.jpg", description: nil, website: nil)
    let assembly = ServicesAssembly(networkClient: MockNetworkClient(), nftStorage: NftStorageImpl())
    let model = MyNFTViewModel(assembly: assembly, profileModel: profile)
    MyNFTView(viewModel: model, profile: profile)
}
