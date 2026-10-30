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
    let collection: NftCollection = NftCollection.peach
    var nfts: [Nft] = Nft.mockNfts
}
