//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 22.10.2026.
//

import SwiftUI

struct CatalogView: View {
    @State private var viewModel = CatalogViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.collections) { collection in
                CatalogCollectionCell(
                    title: collection.name,
                    count: collection.nfts.count,
                    image: Image(collection.cover ?? "collectionCover1")
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(.zero))
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .listRowSpacing(8)
            .padding(.top, 20)
            .padding(.horizontal, 16)
            .background {
                Color.ypWhite
                    .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(.sort42)
                            .renderingMode(.template)
                            .foregroundStyle(.ypBlack)
                    }
                }
            }
        }
    }
}

#Preview {
    CatalogView()
}
