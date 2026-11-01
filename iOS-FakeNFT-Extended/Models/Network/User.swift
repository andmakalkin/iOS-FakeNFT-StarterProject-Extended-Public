//
//  User.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

struct User: Codable, Identifiable, Sendable {
    let id: String
    let name: String
    let rating: Int
    let nfts: [String]
    
    let avatar: String?
    let description: String?
    let website: String?
}
