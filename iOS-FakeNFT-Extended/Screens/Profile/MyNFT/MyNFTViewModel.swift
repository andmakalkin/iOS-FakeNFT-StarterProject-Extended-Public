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
    var nfts: [MyNFTModel] = [MyNFTModel(id: "1", image: Image(.nft1), name: "1", rating: 2, author: "2", price: 2, isLiked: false), MyNFTModel(id: "2", image: Image(.nft1), name: "1", rating: 2, author: "2", price: 2, isLiked: false)]
}
