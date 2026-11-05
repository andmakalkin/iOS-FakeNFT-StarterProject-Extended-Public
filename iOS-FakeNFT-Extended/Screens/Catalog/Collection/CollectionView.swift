//
//  CollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 30.10.2026.
//

import SwiftUI
import Kingfisher

struct CollectionView: View {
    @Environment(AppRouter.self) private var router

    @State private var viewModel: CollectionViewModel

    private var isErrorAlertPresented: Binding<Bool> {
        Binding(
            get: {
                if case .failed = viewModel.state {
                    return true
                }

                return false
            },
            set: { _ in }
        )
    }

    init(
        collectionId: String,
        collectionService: CollectionServiceProtocol,
        nftService: NftService,
        orderService: OrderServiceProtocol,
        profileService: ProfileServiceProtocol
    ) {
        _viewModel = State(
            initialValue: CollectionViewModel(
                collectionId: collectionId,
                collectionService: collectionService,
                nftService: nftService,
                orderService: orderService,
                profileService: profileService
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
                EmptyView()
            }
        }
        .overlay(alignment: .bottom) {
            actionNotificationOverlay
        }
        .animation(
            .easeInOut(duration: 0.3),
            value: viewModel.actionNotification?.id
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
        .alert(
            "Error.loadingData",
            isPresented: isErrorAlertPresented
        ) {
            Button("Error.cancel", role: .cancel) {
                router.popCatalog()
            }

            Button("Error.repeat") {
                Task {
                    await viewModel.loadCollection()
                }
            }
        }
        .task {
            await viewModel.loadCollectionIfNeeded()
        }
    }

    private func contentView(_ content: CollectionViewModel.Content) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                coverView(content.collection.coverURL)
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
                    titleView(content.collection.name)
                        .frame(minHeight: 28)
                        .padding(.bottom, 8)

                    authorView(
                        content.collection.author,
                        url: URL(string: RequestConstants.webViewStub)
                    )
                    .frame(minHeight: 28)

                    if let description = content.collection.description {
                        descriptionView(description)
                    }

                    nftsView(
                        content.nfts,
                        cartNftIds: content.cartNftIds,
                        likedNftIds: content.likedNftIds
                    )
                    .padding(.top, 24)
                }
                .padding(.horizontal, 16)
            }
        }
        .ignoresSafeArea(edges: .top)
        .contentMargins(.bottom, 40, for: .scrollContent)
        .scrollIndicators(.hidden)
    }

    private func coverView(_ url: URL?) -> some View {
        KFImage(url)
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

    private func titleView(_ title: String) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .font(AppFont.bold22)
                .tracking(0.35)
                .foregroundStyle(.ypBlack)

            Spacer()
        }
    }

    private func authorView(_ author: String?, url: URL?) -> some View {
        HStack(spacing: 4) {
            Text("Collection.author")
                .font(AppFont.regular13)
                .tracking(-0.08)
                .foregroundStyle(.ypBlack)

            if let author, !author.isEmpty, let url {
                Button {
                    router.showFullScreen(.webView(url))
                } label: {
                    Text(author)
                        .font(AppFont.regular15)
                        .tracking(-0.24)
                        .foregroundStyle(.ypUniversalBlue)
                }
                .buttonStyle(.plain)
            } else {
                Text(author.flatMap { $0.isEmpty ? nil : $0 } ?? "—")
                    .font(AppFont.regular13)
                    .tracking(-0.08)
                    .foregroundStyle(.ypBlack)
            }

            Spacer()
        }
    }

    private func descriptionView(_ description: String) -> some View {
        HStack(spacing: 0) {
            Text(description)
                .font(AppFont.regular13)
                .tracking(-0.08)
                .foregroundStyle(.ypBlack)

            Spacer()
        }
    }

    private func nftsView(
        _ nfts: [Nft],
        cartNftIds: Set<String>,
        likedNftIds: Set<String>
    ) -> some View {
        let columns = [
            GridItem(
                .adaptive(minimum: 108),
                spacing: 9
            )
        ]

        return LazyVGrid(columns: columns, spacing: 28) {
            ForEach(nfts) { nft in
                CollectionNftCell(
                    onTapLike: {
                        Task {
                            await viewModel.handleTapLike(nftId: nft.id)
                        }
                    },
                    onTapCart: {
                        Task {
                            await viewModel.handleTapCart(nftId: nft.id)
                        }
                    },
                    onTapNft: { router.showModal(.nft(nft.id)) },
                    isLiked: likedNftIds.contains(nft.id),
                    isInCart: cartNftIds.contains(nft.id),
                    isLikeUpdating: viewModel.updatingLikedNftIds.contains(nft.id),
                    isCartUpdating: viewModel.updatingCartNftIds.contains(nft.id),
                    title: nft.name,
                    rating: nft.rating,
                    price: nft.price,
                    imageURL: nft.images.first
                )
            }
        }
    }

    private var backButton: some View {
        Button {
            router.popCatalog()
        } label: {
            Image(.backward24)
                .renderingMode(.template)
                .foregroundStyle(.ypBlack)
                .frame(width: 24, height: 24)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var actionNotificationOverlay: some View {
        if let notification = viewModel.actionNotification {
            actionErrorView(for: notification.error)
                .transition(
                    .opacity.combined(with: .scale(scale: 0.9))
                )
                .padding([.bottom, .horizontal], 16)
                .allowsHitTesting(false)
                .task(id: notification.id) {
                    do {
                        try await Task.sleep(for: .seconds(3))
                        viewModel.dismissActionNotification(id: notification.id)
                    } catch {
                        return
                    }
                }
        }
    }

    private func actionErrorView(
        for error: CollectionViewModel.ActionError
    ) -> some View {
        let message: LocalizedStringKey
        let image: Image

        switch error {
        case .like:
            message = "Collection.error.like"
            image = Image(.favoritesActive40)

        case .cart:
            message = "Collection.error.cart"
            image = Image(.cartAdd40)
        }

        return HStack(spacing: 8) {
            Text(message)
                .font(AppFont.regular17)
                .padding(.leading, 8)

            image
                .renderingMode(.template)
        }
        .contentTransition(.opacity)
        .foregroundStyle(.ypWhite)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ypBlack)
        }
    }
}

#Preview {
    let networkClient = MockNetworkClient()

    return NavigationStack {
        CollectionView(
            collectionId: "1",
            collectionService: CollectionService(
                networkClient: networkClient
            ),
            nftService: NftServiceImpl(
                networkClient: networkClient,
                storage: NftStorageImpl()
            ),
            orderService: OrderService(
                networkClient: networkClient
            ),
            profileService: ProfileService(
                networkClient: networkClient
            )
        )
    }
    .environment(AppRouter())
}
