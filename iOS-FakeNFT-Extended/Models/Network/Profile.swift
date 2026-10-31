//
//  Profile.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-29.
//

import Foundation

struct Profile: Codable, Identifiable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String?
    let id: String
}
