//
//  Logger+Categories.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 25.10.2026.
//

import Foundation
import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "FakeNFT"
    
    static let catalog = Logger(
        subsystem: subsystem,
        category: "Catalog"
    )
}
