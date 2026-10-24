//
//  NftCollection.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 22.10.2026.
//

import Foundation

struct NftCollection: Codable, Identifiable, Sendable {
    let id: String
    let name: String
    let nfts: [String]

    let createdAt: String?
    let cover: String?
    let description: String?
    let author: String?
    let website: String?
}

extension NftCollection {
    var coverURL: URL? {
        guard let cover else {
            return nil
        }

        return URL(string: cover)
    }
}
