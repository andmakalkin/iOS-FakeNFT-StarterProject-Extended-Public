//
//  MyNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-02.
//
import Observation
import SwiftUI

@Observable
final class MyNFTViewModel {
    private var nfts: [MyNFTModel] = [MyNFTModel(id: "1", image: Image(.nft1), name: "gfg", rating: 2, author: "2", price: 2, isLiked: false), MyNFTModel(id: "2", image: Image(.nft1), name: "sdf", rating: 2, author: "2", price: 20, isLiked: false)]
    
    var currentFilter: MyNFTFilters?
    
    var filtredNFTs: [MyNFTModel] {
        switch currentFilter {
        case .price:
            return nfts.sorted {
                $0.price > $1.price
            }
        case .rating:
            return nfts.sorted {
                $0.rating > $1.rating
            }
        case .name:
            return nfts.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case nil:
            return nfts
        }
    }
}
