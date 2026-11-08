//
//  FavoritesNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-07.
//

import SwiftUI

struct FavoritesNFTView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel: FavoritesNFTViewModel
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(.backward24)
                                .frame(width: 24, height: 24)
                        }
                        Spacer()
                    }
                    Text("Избранные NFT")
                        .font(AppFont.bold17)
                        .foregroundStyle(.ypBlack)
                }
                .padding(EdgeInsets(top: 9, leading: 9, bottom: 9, trailing: 9))
                
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 7),
                            GridItem(.flexible(), spacing: 7)
                        ],
                        spacing: 20
                    ) {
                        ForEach(viewModel.nfts, id: \.id) { nft in
                            FavoriteNFTCell(nft: nft) {
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
            .padding(EdgeInsets(top: 2, leading: 0, bottom: 20, trailing: 0))
            
            Text("У Вас ещё нет избранных NFT")
                .font(AppFont.bold17)
                .foregroundStyle(.ypBlack)
                .opacity((viewModel.nfts.isEmpty && !viewModel.isLoading) ? 1 : 0)
        }
        .navigationBarBackButtonHidden()
        .task {
            await viewModel.loadNfts()
        }
    }
}

#Preview {
    let profile = Profile(id: "1", name: "name", nfts: ["1","2"], likes: ["1", "2", "3"], avatar: "https://i.pinimg.com/1200x/d3/49/1b/d3491b2125cd256caeb793aa8b9fa748.jpg", description: "description", website: nil)
    let assembly = ServicesAssembly(networkClient: MockNetworkClient(), nftStorage: NftStorageImpl())
    let vm = FavoritesNFTViewModel(assembly: assembly, profileModel: profile)
    FavoritesNFTView(viewModel: vm)
}
