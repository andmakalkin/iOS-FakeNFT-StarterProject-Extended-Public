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
    var collection: NftCollection = NftCollection.peach
    var nfts: [Nft] = Nft.mockNfts
    
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
        do {
            let collection = try await collectionService.loadCollection(id: collectionId)
            self.collection = collection
        } catch is CancellationError {
            return
        } catch {
            return
        }
    }
}
