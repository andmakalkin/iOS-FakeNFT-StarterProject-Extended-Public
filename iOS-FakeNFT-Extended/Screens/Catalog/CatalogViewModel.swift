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
    enum State {
        case initial
        case loadingFirstPage
        case loadingNextPage
        case loaded
        case failedFirstPage(Error)
        case failedNextPage(Error)
    }
    
    private(set) var collections: [NftCollection] = []
    private(set) var state: State = .initial
    
    private var nextPage = 1
    private var hasMorePages = true
    
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
    
    private var networkSortOption: CollectionsSortOption {
        switch sortOption {
        case .name:
            .nameAscending
        case .nftCount:
            .nftCountDescending
        }
    }
    
    init(
        collectionService: CollectionServiceProtocol,
        userDefaultsService: UserDefaultsServiceProtocol
    ) {
        self.collectionService = collectionService
        self.userDefaultsService = userDefaultsService
        self.sortOption = userDefaultsService.fetchCatalogSortOption() ?? .nftCount
    }
    
    func handleSortByName() {
        sortOption = .name
    }
    
    func handleSortByNftCount() {
        sortOption = .nftCount
    }

    func loadFirstPage() async {
        state = .loadingFirstPage
        nextPage = 1
        hasMorePages = true

        do {
            let firstPage = try await collectionService.loadCollections(
                page: 0,
                sortBy: networkSortOption
            )

            collections = firstPage

            guard !firstPage.isEmpty else {
                hasMorePages = false
                state = .loaded
                return
            }

            sortCollections()
            state = .loaded
        } catch {
            state = .failedFirstPage(error)
        }
    }
    
    func loadNextPage() async {
        guard case .loaded = state else {
            return
        }

        await performNextPageLoading()
    }
    
    func retryLoading() async {
        switch state {
        case .failedFirstPage:
            await loadFirstPage()
        case .failedNextPage:
            await performNextPageLoading()
        default:
            return
        }
    }
    
    func dismissError() {
        switch state {
        case .failedFirstPage:
            state = .initial
        case .failedNextPage:
            state = .loaded
        default:
            return
        }
    }
    
    private func performNextPageLoading() async {
        guard hasMorePages else {
            return
        }

        state = .loadingNextPage

        do {
            let page = try await collectionService.loadCollections(
                page: nextPage,
                sortBy: networkSortOption
            )

            guard !page.isEmpty else {
                hasMorePages = false
                state = .loaded
                return
            }

            collections += page
            nextPage += 1
            sortCollections()
            state = .loaded
        } catch {
            state = .failedNextPage(error)
        }
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
