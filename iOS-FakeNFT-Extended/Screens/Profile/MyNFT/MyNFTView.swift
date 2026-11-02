//
//  MyNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-01.
//

import SwiftUI

struct MyNFTView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel = MyNFTViewModel()
    
    @State private var isFiltersShow = false
    @State private var currentFilter: MyNFTFilters?
    
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
                        ForEach(viewModel.nfts) { nft in
                            NFTCell(nft: nft)
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                Spacer()
            }
            
            if viewModel.nfts.isEmpty {
                Text("У Вас ещё нет NFT")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.ypBlack)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .confirmationDialog("Сортировка", isPresented: $isFiltersShow, titleVisibility: .visible) {
            Button("По цене") {
                currentFilter = .price
            }
            Button("По рейтингу") {
                currentFilter = .rating
            }
            Button("По названию") {
                currentFilter = .name
            }
        }
    }
}

#Preview {
    MyNFTView()
}
