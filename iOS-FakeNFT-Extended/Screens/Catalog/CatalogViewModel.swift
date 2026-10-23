//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 22.10.2026.
//

import Foundation

@MainActor
@Observable
final class CatalogViewModel {
    var collections: [NftCollection] = NftCollection.mockCollections
    
    private let userDefaultsService: UserDefaultsServiceProtocol
    
    init(userDefaultsService: UserDefaultsServiceProtocol) {
        self.userDefaultsService = userDefaultsService
    }
}
