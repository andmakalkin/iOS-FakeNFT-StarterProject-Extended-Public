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
    private let collectionId: String
    var collection: NftCollection = NftCollection.peach
    var nfts: [Nft] = Nft.mockNfts
    
    // MARK: - Dependencies

    private let collectionService: CollectionServiceProtocol
    
    init(
        collectionId: String,
        collectionService: CollectionServiceProtocol
    ) {
        self.collectionId = collectionId
        self.collectionService = collectionService
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
