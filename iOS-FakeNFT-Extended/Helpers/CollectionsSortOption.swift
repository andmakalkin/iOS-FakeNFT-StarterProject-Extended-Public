//
//  CollectionsSortOption.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 24.10.2026.
//

enum CollectionsSortOption: Sendable {
    case nameAscending
    case nftCountDescending
    
    var queryValue: String {
        switch self {
        case .nameAscending: "name,asc"
        case .nftCountDescending: "nfts,desc"
        }
    }
}
