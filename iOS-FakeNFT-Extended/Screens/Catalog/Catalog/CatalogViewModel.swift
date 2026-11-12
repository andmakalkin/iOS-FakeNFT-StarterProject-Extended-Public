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

    // MARK: - Dependencies

    private let collectionService: CollectionServiceProtocol
    private let userDefaultsService: UserDefaultsServiceProtocol

    // MARK: - State

    enum State {
        case initial
        case loadingFirstPage
        case loadingNextPage
        case loaded
        case failedFirstPage(Error)
        case failedNextPage(Error)
        case failedFirstPageDismissed
    }

    private(set) var state: State = .initial
    private(set) var collections: [NftCollection] = []

    private var sortOption: CatalogSortOption
    private var nextPage = 1
    private var hasMorePages = true
    private var requestID = UUID()

    // MARK: - Init

    init(
        collectionService: CollectionServiceProtocol,
        userDefaultsService: UserDefaultsServiceProtocol
    ) {
        self.collectionService = collectionService
        self.userDefaultsService = userDefaultsService
        self.sortOption = userDefaultsService.fetchCatalogSortOption() ?? .nftCount
    }

    // MARK: - Computed Properties

    private var networkSortOption: CollectionsSortOption {
        switch sortOption {
        case .name:
            .nameAscending
        case .nftCount:
            .nftCountDescending
        }
    }

    // MARK: - Public Methods

    func loadInitialPageIfNeeded() async {
        guard case .initial = state else {
            return
        }

        await loadFirstPage()
    }

    func loadNextPage() async {
        guard case .loaded = state,
              sortOption == .name else {
            return
        }

        await performNextPageLoading()
    }

    func retryLoading() async {
        switch state {
        case .failedFirstPage, .failedFirstPageDismissed:
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
            state = .failedFirstPageDismissed

        case .failedNextPage:
            state = .loaded

        default:
            return
        }
    }

    func handleSortByName() async {
        await changeSortOption(to: .name)
    }

    func handleSortByNftCount() async {
        await changeSortOption(to: .nftCount)
    }

    // MARK: - Private Methods

    private func loadFirstPage() async {
        state = .loadingFirstPage
        nextPage = 1
        hasMorePages = true

        let requestedID = requestID
        let requestedSortOption = networkSortOption

        do {
            let firstPage = try await collectionService.loadCollections(
                page: 0,
                sortBy: requestedSortOption
            )

            guard requestedID == requestID else {
                return
            }

            try Task.checkCancellation()

            guard !firstPage.isEmpty else {
                collections = []
                hasMorePages = false
                state = .loaded
                return
            }

            if sortOption == .nftCount {
                var allCollections = firstPage
                var page = 1

                while true {
                    try Task.checkCancellation()

                    let nextPage = try await collectionService.loadCollections(
                        page: page,
                        sortBy: requestedSortOption
                    )

                    guard requestedID == requestID else {
                        return
                    }

                    try Task.checkCancellation()

                    guard !nextPage.isEmpty else {
                        break
                    }

                    allCollections.append(contentsOf: nextPage)
                    page += 1
                }

                collections = allCollections.sorted {
                    if $0.uniqueNftCount == $1.uniqueNftCount {
                        return $0.name.localizedCaseInsensitiveCompare($1.name)
                            == .orderedAscending
                    }

                    return $0.uniqueNftCount > $1.uniqueNftCount
                }

                hasMorePages = false
            } else {
                collections = firstPage
            }

            state = .loaded

        } catch is CancellationError {
            guard requestedID == requestID else {
                return
            }

            state = .initial

        } catch {
            guard requestedID == requestID else {
                return
            }

            if Task.isCancelled || (error as? URLError)?.code == .cancelled {
                state = .initial
                return
            }

            Logger.catalog.error(
                "Не удалось загрузить первую страницу каталога: \(String(describing: error), privacy: .public)"
            )

            state = .failedFirstPage(error)
        }
    }

    private func performNextPageLoading() async {
        guard hasMorePages, sortOption == .name else {
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

            try Task.checkCancellation()

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

            if Task.isCancelled || (error as? URLError)?.code == .cancelled {
                state = .loaded
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
