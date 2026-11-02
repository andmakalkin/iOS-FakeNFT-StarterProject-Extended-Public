//
//  MyNFTModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-02.
//
import SwiftUI

struct MyNFTModel: Identifiable {
    let id: String
    let image: Image
    let name: String
    let rating: Int
    let author: String
    let price: Double
    let isLiked: Bool
    
    var formattedPrice: String {
        String(format: "%.2f", price)
    }
}
