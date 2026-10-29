//
//  Order.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//

import Foundation

struct Order: Codable, Identifiable, Sendable {
    let nfts: [String]
    let id: String
}
