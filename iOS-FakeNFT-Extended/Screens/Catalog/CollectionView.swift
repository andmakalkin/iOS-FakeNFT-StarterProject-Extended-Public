//
//  CollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 30.10.2026.
//

import SwiftUI
import Kingfisher

struct CollectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: CollectionViewModel
    
    init(
        collectionId: String,
        collectionService: CollectionServiceProtocol,
        nftService: NftService
    ) {
        _viewModel = State(
            initialValue: CollectionViewModel(
                collectionId: collectionId,
                collectionService: collectionService,
                nftService: nftService
            )
        )
    }
    
    var body: some View {
        ZStack {
            Color.ypWhite
                .ignoresSafeArea()
            
            switch viewModel.state {
            case .initial, .loading:
                ProgressView()

            case .loaded(let content):
                contentView(content)
            
            case .failed:
                Text("Ошибка")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
        .task {
            await viewModel.loadCollection()
        }
    }
    
    private func contentView(_ content: CollectionViewModel.Content) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                coverView(content.collection)
                    .frame(maxWidth: .infinity)
                    .frame(height: 310)
                    .clipShape(
                        UnevenRoundedRectangle(
                            cornerRadii: RectangleCornerRadii(
                                bottomLeading: 12,
                                bottomTrailing: 12
                            )
                        )
                    )
                
                VStack(alignment: .leading, spacing: 0) {
                    titleView(content.collection)
                        .frame(minHeight: 28)
                        .padding(.bottom, 8)
                    
                    authorView(content.collection)
                        .frame(minHeight: 28)
                    
                    if content.collection.description != nil {
                        descriptionView(content.collection)
                    }
                    
                    nftsView(content.nfts)
                        .padding(.top, 24)
                }
                .padding(.horizontal, 16)
            }
        }
        .ignoresSafeArea(edges: .top)
        .contentMargins(.bottom, 40, for: .scrollContent)
        .scrollIndicators(.hidden)
    }
    
    private func coverView(_ collection: NftCollection) -> some View {
        KFImage(collection.coverURL)
            .placeholder {
                ShimmerPlaceholderView()
            }
            .onFailureView {
                ZStack {
                    Color.imagePlaceholderBackground
                    
                    Image(.imageStub)
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(0.3)
                }
            }
            .cancelOnDisappear(true)
            .fade(duration: 0.3)
            .resizable()
            .scaledToFill()
        
    }
    
    private func titleView(_ collection: NftCollection) -> some View {
        HStack(spacing: 0) {
            Text(collection.name)
                .font(AppFont.bold22)
                .tracking(0.35)
                .foregroundStyle(.ypBlack)
            
            Spacer()
        }
    }
    
    private func authorView(_ collection: NftCollection) -> some View {
        HStack(spacing: 4) {
            Text("Collection.author")
                .font(AppFont.regular13)
                .tracking(-0.08)
                .foregroundStyle(.ypBlack)
            
            Text(collection.author ?? "—")
                .font(AppFont.regular15)
                .tracking(-0.24)
                .foregroundStyle(.ypUniversalBlue)
            
            Spacer()
        }
    }
    
    private func descriptionView(_ collection: NftCollection) -> some View {
        HStack(spacing: 0) {
            Text(collection.description ?? "")
                .font(AppFont.regular13)
                .tracking(-0.08)
                .foregroundStyle(.ypBlack)
            
            Spacer()
        }
    }
    
    private func nftsView(_ nfts: [Nft]) -> some View {
        let columns = [
            GridItem(
                .adaptive(minimum: 108),
                spacing: 9
            )
        ]
        
        return LazyVGrid(columns: columns, spacing: 28) {
            ForEach(nfts) { nft in
                CollectionNftCell(
                    onTapLike: {},
                    onTapCart: {},
                    onTapNft: {},
                    isLiked: true,
                    isInCart: true,
                    title: nft.name,
                    rating: nft.rating,
                    price: nft.price,
                    imageURL: nil,
                    imageString: "nft\(nft.id)"
                )
            }
        }
    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(.backward24)
                .renderingMode(.template)
                .foregroundStyle(.ypBlack)
                .frame(width: 24, height: 24)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        CollectionView(
            collectionId: "1",
            collectionService: CollectionService(
                networkClient: MockNetworkClient()
            ),
            nftService: NftServiceImpl(
                networkClient: MockNetworkClient(),
                storage: NftStorageImpl()
            )
        )
    }
}
