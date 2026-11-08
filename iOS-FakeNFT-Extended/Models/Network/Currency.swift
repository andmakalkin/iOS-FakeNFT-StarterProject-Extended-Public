//
//  Currency.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//

import Foundation

struct Currency: Codable, Identifiable, Hashable {
    let title: String
    let name: String
    let image: URL
    let id: String         
}
