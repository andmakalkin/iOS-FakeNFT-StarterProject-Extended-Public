//
//  AppRoute.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 04.11.2026.
//

import Foundation

enum AppRoute: Hashable, Identifiable {
    case collection(String)
    case webView(URL)
    case nft(String)

    var id: Self { self }
}
