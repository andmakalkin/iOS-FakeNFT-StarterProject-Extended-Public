//
//  MyNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-01.
//

import SwiftUI

struct MyNFTView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel = MyNFTViewModel(nftService: NftServiceImpl(networkClient: MockNetworkClient(), storage: NftStorageImpl()))
    
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
                                .frame(width: 24, height: 24)
                        }
                        Spacer()
                        Button {
                            isFiltersShow = true
                        } label: {
                            Image(.sort42)
                                .frame(width: 42, height: 42)
                        }

                    }
                    Text("Мои NFT")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.ypBlack)
                }
                .padding(EdgeInsets(top: 9, leading: 9, bottom: 9, trailing: 9))
                
                ScrollView {
                    LazyVStack(spacing: 32) {
                        ForEach(viewModel.filtredNFTs) { nft in
                            NFTCell(nft: nft)
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                Spacer()
            }
            
            if viewModel.filtredNFTs.isEmpty {
                Text("У Вас ещё нет NFT")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.ypBlack)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    let profile = Profile(name: "name", avatar: "https://i.pinimg.com/1200x/d3/49/1b/d3491b2125cd256caeb793aa8b9fa748.jpg", description: "description", website: "", nfts: ["1","2"], rating: nil, id: "1")
    MyNFTView(profile: profile)
}
