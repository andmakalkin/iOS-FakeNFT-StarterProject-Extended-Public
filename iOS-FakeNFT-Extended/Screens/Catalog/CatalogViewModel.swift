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
    
    private let collectionService: CollectionServiceProtocol
    private let userDefaultsService: UserDefaultsServiceProtocol
    
    private var sortOption: CatalogSortOption {
        didSet {
            guard sortOption != oldValue else {
                return
            }
            
            userDefaultsService.saveCatalogSortOption(sortOption)
            sortCollections()
        }
    }
    
    init(
        collectionService: CollectionServiceProtocol,
        userDefaultsService: UserDefaultsServiceProtocol
    ) {
        self.collectionService = collectionService
        self.userDefaultsService = userDefaultsService
        self.sortOption = userDefaultsService.fetchCatalogSortOption() ?? .nftCount
        
        sortCollections()
    }
    
    func handleSortByName() {
        sortOption = .name
    }
    
    func handleSortByNftCount() {
        sortOption = .nftCount
    }
    
    private func sortCollections() {
        switch sortOption {
        case .name:
            collections.sort(
                by:
                    { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            )
            
        case .nftCount:
            collections.sort {
                if $0.nfts.count == $1.nfts.count {
                    return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }
                
                return $0.nfts.count > $1.nfts.count
            }
        }
    }
}
