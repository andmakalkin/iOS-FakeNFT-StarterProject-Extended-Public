//
//  CollectionService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 24.10.2026.
//

import Foundation

protocol CollectionServiceProtocol: Sendable {
    func loadCollections(page: Int, sortBy: CollectionsSortOption) async throws -> [NftCollection]
}

actor CollectionService: CollectionServiceProtocol {
    private static let pageSize = 25
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCollections(page: Int, sortBy: CollectionsSortOption) async throws -> [NftCollection] {
        let request = CollectionsRequest(
            page: page,
            size: Self.pageSize,
            sortBy: sortBy
        )
        
        return try await networkClient.send(request: request)
    }
}
