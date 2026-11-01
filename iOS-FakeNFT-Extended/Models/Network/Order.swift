//
//  Order.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

struct Order: Codable, Identifiable, Sendable {
    let id: String
    let nfts: [String]
}
