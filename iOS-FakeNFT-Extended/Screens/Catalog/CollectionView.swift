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
        ScrollView {
            VStack(spacing: 16) {
                coverView
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
                    titleView
                        .frame(minHeight: 28)
                        .padding(.bottom, 8)
                    
                    authorView
                        .frame(minHeight: 28)
                    
                    if viewModel.collection.description != nil {
                        descriptionView
                    }
                    
                    nftsView
                        .padding(.top, 24)
                }
                .padding(.horizontal, 16)
            }
        }
        .ignoresSafeArea(edges: .top)
        .contentMargins(.bottom, 40, for: .scrollContent)
        .scrollIndicators(.hidden)
        .background(.ypWhite)
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
    
    private var coverView: some View {
        KFImage(viewModel.collection.coverURL)
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
    
    private var titleView: some View {
        HStack(spacing: 0) {
            Text(viewModel.collection.name)
                .font(AppFont.bold22)
                .tracking(0.35)
                .foregroundStyle(.ypBlack)
            
            Spacer()
        }
    }
    
    private var authorView: some View {
        HStack(spacing: 4) {
            Text("Collection.author")
                .font(AppFont.regular13)
                .tracking(-0.08)
                .foregroundStyle(.ypBlack)
            
            Text(viewModel.collection.author ?? "—")
                .font(AppFont.regular15)
                .tracking(-0.24)
                .foregroundStyle(.ypUniversalBlue)
            
            Spacer()
        }
    }
    
    private var descriptionView: some View {
        HStack(spacing: 0) {
            Text(viewModel.collection.description ?? "")
                .font(AppFont.regular13)
                .tracking(-0.08)
                .foregroundStyle(.ypBlack)
            
            Spacer()
        }
    }
    
    private var nftsView: some View {
        let columns = [
            GridItem(
                .adaptive(minimum: 108),
                spacing: 9
            )
        ]
        
        return LazyVGrid(columns: columns, spacing: 28) {
            ForEach(viewModel.nfts) { nft in
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
