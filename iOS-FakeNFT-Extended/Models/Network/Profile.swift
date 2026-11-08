//
//  Profile.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

struct Profile: Codable, Identifiable, Sendable {
    let id: String
    let name: String
    let nfts: [String]
    let likes: [String]

    let avatar: String?
    let description: String?
    let website: String?
}
