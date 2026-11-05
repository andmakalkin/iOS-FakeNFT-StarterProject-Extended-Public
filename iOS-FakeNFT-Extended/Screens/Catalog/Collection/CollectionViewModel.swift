//
//  CollectionViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 30.10.2026.
//

import Foundation
import OSLog

@MainActor
@Observable

final class CollectionViewModel {

    // MARK: - State

    enum State {
        case initial
        case loading
        case loaded(Content)
        case failed(Error)
    }

    struct Content {
        let collection: NftCollection
        let nfts: [Nft]
        let cartNftIds: Set<String>
        let likedNftIds: Set<String>
    }

    private let collectionId: String
    private(set) var state: State = .initial
    private(set) var updatingLikedNftIds: Set<String> = []
    private(set) var updatingCartNftIds: Set<String> = []

    // MARK: - Dependencies

    private let collectionService: CollectionServiceProtocol
    private let nftService: NftService
    private let orderService: OrderServiceProtocol
    private let profileService: ProfileServiceProtocol

    // MARK: - Init

    init(
        collectionId: String,
        collectionService: CollectionServiceProtocol,
        nftService: NftService,
        orderService: OrderServiceProtocol,
        profileService: ProfileServiceProtocol
    ) {
        self.collectionId = collectionId
        self.collectionService = collectionService
        self.nftService = nftService
        self.orderService = orderService
        self.profileService = profileService
    }

    // MARK: - Actions

    func loadCollectionIfNeeded() async {
        guard case .initial = state else {
            return
        }

        await loadCollection()
    }
    
    func loadCollection() async {
        state = .loading

        do {
            let collection = try await collectionService.loadCollection(id: collectionId)

            async let nfts = loadNfts(ids: collection.uniqueNfts)
            async let order = orderService.loadOrder()
            async let profile = profileService.loadProfile()

            let (loadedNfts, loadedOrder, loadedProfile) = try await (nfts, order, profile)

            let content = Content(
                collection: collection,
                nfts: loadedNfts,
                cartNftIds: Set(loadedOrder.nfts),
                likedNftIds: Set(loadedProfile.likes)
            )

            state = .loaded(content)

        } catch is CancellationError {
            state = .initial

            return
        } catch {
            Logger.collection.error(
                "Не удалось загрузить коллекцию \(self.collectionId, privacy: .public): \(String(describing: error), privacy: .public)"
            )

            state = .failed(error)
        }
    }

    func handleTapLike(nftId: String) async {
        guard !updatingLikedNftIds.contains(nftId) else { return }

        updatingLikedNftIds.insert(nftId)

        defer {
            updatingLikedNftIds.remove(nftId)
        }

        do {
            try await toggleLike(nftId: nftId)
        } catch is CancellationError {
            return
        } catch {
            Logger.collection.error(
                "Не удалось изменить лайк NFT \(nftId, privacy: .public): \(String(describing: error), privacy: .public)"
            )
        }
    }

    func handleTapCart(nftId: String) async {
        guard !updatingCartNftIds.contains(nftId) else { return }
        
        updatingCartNftIds.insert(nftId)
        
        defer {
            updatingCartNftIds.remove(nftId)
        }
        
        do {
            try await toggleCart(nftId: nftId)
        } catch is CancellationError {
            return
        } catch {
            Logger.collection.error(
                "Не удалось изменить корзину NFT \(nftId, privacy: .public): \(String(describing: error))"
            )
        }
    }

    // MARK: - Helpers

    private func loadNfts(ids: [String]) async throws -> [Nft] {
        try await withThrowingTaskGroup(
            of: (Int, Nft).self
        ) { group in
            for (index, id) in ids.enumerated() {
                group.addTask { [nftService] in
                    let nft = try await nftService.loadNft(id: id)
                    return (index, nft)
                }
            }

            var loadedNfts = Array<Nft?>(
                repeating: nil,
                count: ids.count
            )

            for try await (index, nft) in group {
                loadedNfts[index] = nft
            }

            return loadedNfts.compactMap { $0 }
        }
    }

    private func toggleLike(nftId: String) async throws {
        guard case .loaded = state else { return }

        let updatedProfile = try await profileService.toggleLike(nftId: nftId)

        guard case .loaded(let currentContent) = state else { return }

        let updatedContent = Content(
            collection: currentContent.collection,
            nfts: currentContent.nfts,
            cartNftIds: currentContent.cartNftIds,
            likedNftIds: Set(updatedProfile.likes)
        )

        state = .loaded(updatedContent)
    }

    private func toggleCart(nftId: String) async throws {
        guard case .loaded = state else { return }

        let updatedOrder = try await orderService.toggleCart(nftId: nftId)

        guard case .loaded(let currentContent) = state else { return }

        let updatedContent = Content(
            collection: currentContent.collection,
            nfts: currentContent.nfts,
            cartNftIds: Set(updatedOrder.nfts),
            likedNftIds: currentContent.likedNftIds
        )

        state = .loaded(updatedContent)
    }
}
