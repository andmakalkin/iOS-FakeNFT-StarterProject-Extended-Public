//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 22.10.2026.
//

import Foundation
import OSLog

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
    private var requestID = UUID()
    
    private let collectionService: CollectionServiceProtocol
    private let userDefaultsService: UserDefaultsServiceProtocol
    
    private var sortOption: CatalogSortOption
    
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
    
    func handleSortByName() async {
        await changeSortOption(to: .name)
    }
    
    func handleSortByNftCount() async {
        await changeSortOption(to: .nftCount)
    }
    
    func loadFirstPage() async {
        state = .loadingFirstPage
        nextPage = 1
        hasMorePages = true
        
        let requestedID = requestID
        
        do {
            let firstPage = try await collectionService.loadCollections(
                page: 0,
                sortBy: networkSortOption
            )
            
            guard requestedID == requestID else {
                return
            }
            
            collections = firstPage
            
            guard !firstPage.isEmpty else {
                hasMorePages = false
                state = .loaded
                return
            }
            
            state = .loaded
        } catch is CancellationError {
            return
        } catch {
            guard requestedID == requestID else {
                return
            }
            
            Logger.catalog.error(
                "Не удалось загрузить первую страницу каталога: \(String(describing: error), privacy: .public)"
            )
            
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
        
        let requestedID = requestID
        
        do {
            let page = try await collectionService.loadCollections(
                page: nextPage,
                sortBy: networkSortOption
            )
            
            guard requestedID == requestID else {
                return
            }
            
            guard !page.isEmpty else {
                hasMorePages = false
                state = .loaded
                return
            }
            
            collections += page
            nextPage += 1
            state = .loaded
        } catch is CancellationError {
            guard requestedID == requestID else {
                return
            }

            state = .loaded
        } catch {
            guard requestedID == requestID else {
                return
            }
            
            Logger.catalog.error(
                "Не удалось загрузить страницу каталога \(self.nextPage): \(String(describing: error), privacy: .public)"
            )
            
            state = .failedNextPage(error)
        }
    }
    
    private func changeSortOption(to option: CatalogSortOption) async {
        guard option != sortOption else {
            return
        }
        
        sortOption = option
        userDefaultsService.saveCatalogSortOption(sortOption)
        
        requestID = UUID()
        collections = []
        
        await loadFirstPage()
    }
}
