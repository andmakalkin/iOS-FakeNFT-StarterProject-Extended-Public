//
//  MockNetworkClient.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 24.10.2026.
//

import Foundation

actor MockNetworkClient: NetworkClient {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    func send(request: NetworkRequest) async throws -> Data {
        guard let endpoint = request.endpoint else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }

        let collectionsPath = "/api/v1/collections"
        let nftPath = "/api/v1/nft"

        try await Task.sleep(for: .seconds(1))

        if endpoint.path == collectionsPath {
            let collections = try loadCollections()

            return try makeCollectionsPage(
                from: collections,
                endpoint: endpoint
            )
        }

        if endpoint.path.hasPrefix("\(collectionsPath)/") {
            let collections = try loadCollections()

            return try makeCollectionById(
                from: collections,
                endpoint: endpoint
            )
        }

        if endpoint.path.hasPrefix("\(nftPath)/") {
            let nfts = try loadNfts()

            return try makeNftById(
                from: nfts,
                endpoint: endpoint
            )
        }

        throw NetworkClientError.incorrectRequest(
            "Mock response not found for \(endpoint.path)"
        )
    }

    func send<T: Decodable>(
        request: NetworkRequest
    ) async throws -> T {
        let data = try await send(request: request)
        return try await parse(data: data)
    }

    // MARK: - Private

    private func parse<T: Decodable>(
        data: Data
    ) async throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkClientError.parsingError
        }
    }

    private func loadCollections() throws -> [NftCollection] {
        guard let fileURL = Bundle.main.url(
            forResource: "mockCollections",
            withExtension: "json"
        ) else {
            throw NetworkClientError.incorrectRequest(
                "mockCollections.json not found"
            )
        }

        let data = try Data(contentsOf: fileURL)

        do {
            return try decoder.decode(
                [NftCollection].self,
                from: data
            )
        } catch {
            throw NetworkClientError.parsingError
        }
    }

    private func loadNfts() throws -> [Nft] {
        guard let fileURL = Bundle.main.url(
            forResource: "mockNfts",
            withExtension: "json"
        ) else {
            throw NetworkClientError.incorrectRequest(
                "mockNfts.json not found"
            )
        }

        let data = try Data(contentsOf: fileURL)

        do {
            return try decoder.decode(
                [Nft].self,
                from: data
            )
        } catch {
            throw NetworkClientError.parsingError
        }
    }

    private func makeCollectionsPage(
        from collections: [NftCollection],
        endpoint: URL
    ) throws -> Data {
        guard let components = URLComponents(
            url: endpoint,
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkClientError.incorrectRequest(
                "Invalid endpoint"
            )
        }

        let page = queryValue(
            named: "page",
            in: components
        ).flatMap(Int.init) ?? 0

        let size = queryValue(
            named: "size",
            in: components
        ).flatMap(Int.init) ?? 25

        let sortBy = queryValue(
            named: "sortBy",
            in: components
        )

        let sortedCollections = sort(
            collections,
            by: sortBy
        )

        let startIndex = page * size

        guard startIndex < sortedCollections.count else {
            return try encoder.encode([NftCollection]())
        }

        let endIndex = min(
            startIndex + size,
            sortedCollections.count
        )

        let pageCollections = Array(
            sortedCollections[startIndex..<endIndex]
        )

        return try encoder.encode(pageCollections)
    }

    private func makeCollectionById(
        from collections: [NftCollection],
        endpoint: URL
    ) throws -> Data {
        let id = endpoint.lastPathComponent

        guard let collection = collections.first(
            where: { $0.id == id }
        ) else {
            throw NetworkClientError.httpStatusCode(404)
        }

        return try encoder.encode(collection)
    }

    private func makeNftById(
        from nfts: [Nft],
        endpoint: URL
    ) throws -> Data {
        let id = endpoint.lastPathComponent

        guard let nft = nfts.first(
            where: { $0.id == id }
        ) else {
            throw NetworkClientError.httpStatusCode(404)
        }

        return try encoder.encode(nft)
    }

    private func queryValue(
        named name: String,
        in components: URLComponents
    ) -> String? {
        components.queryItems?
            .first { $0.name == name }?
            .value
    }

    private func sort(
        _ collections: [NftCollection],
        by sortBy: String?
    ) -> [NftCollection] {
        switch sortBy {
        case CollectionsSortOption.nameAscending.queryValue:
            return collections.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name)
                    == .orderedAscending
            }

        case CollectionsSortOption.nftCountDescending.queryValue:
            return collections.sorted {
                if $0.nfts.count == $1.nfts.count {
                    return $0.name.localizedCaseInsensitiveCompare($1.name)
                        == .orderedAscending
                }

                return $0.nfts.count > $1.nfts.count
            }

        default:
            return collections
        }
    }
}
