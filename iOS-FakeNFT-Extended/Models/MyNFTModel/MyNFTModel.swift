//
//  MyNFTModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-02.
//

import Foundation

struct MyNFTModel: Identifiable {
    let id: String
    let image: URL?
    let name: String
    let rating: Int
    let author: String
    let price: Double
    let isLiked: Bool
    
    var formattedPrice: String {
        String(format: "%.2f", price)
    }
    
    init(nft: Nft) {
        self.id = nft.id
        self.image = nft.images.first
        self.name = nft.name
        self.rating = nft.rating
        self.author = nft.author
        self.price = nft.price
        self.isLiked = false
    }
}
