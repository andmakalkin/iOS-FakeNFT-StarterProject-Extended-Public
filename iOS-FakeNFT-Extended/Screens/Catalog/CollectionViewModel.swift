//
//  CollectionViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 30.10.2026.
//

import Foundation

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
    }
    
    private(set) var state: State = .initial
    private let collectionId: String

    // MARK: - Dependencies

    private let collectionService: CollectionServiceProtocol
    private let nftService: NftService
    
    init(
        collectionId: String,
        collectionService: CollectionServiceProtocol,
        nftService: NftService
    ) {
        self.collectionId = collectionId
        self.collectionService = collectionService
        self.nftService = nftService
    }
    
    func loadCollection() async {
        state = .loading
        
        do {
            let collection = try await collectionService.loadCollection(id: collectionId)
            
            let nfts = try await loadNfts(
                ids: collection.nfts
            )
            
            let content = Content(
                collection: collection,
                nfts: nfts
            )
            
            state = .loaded(content)
            
        } catch is CancellationError {
            return
        } catch {
            state = .failed(error)
        }
    }
    
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
}
