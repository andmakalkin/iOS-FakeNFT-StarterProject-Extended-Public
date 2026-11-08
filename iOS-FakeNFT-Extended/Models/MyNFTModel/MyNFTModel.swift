//
//  MyNFTModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-02.
//

import Foundation

struct MyNFTModel: Identifiable {
    let id: String
    let imageURL: URL?
    let name: String
    let rating: Int
    let author: String
    let price: Double
    var isLiked: Bool
    
    var formattedPrice: String {
        String(format: "%.2f", price)
    }

    init(nft: Nft, isLiked: Bool = false) {
        self.id = nft.id
        self.imageURL = nft.images.first
        self.name = nft.name
        self.rating = nft.rating
        self.author = nft.author ?? ""
        self.price = nft.price
        self.isLiked = isLiked
    }
}
