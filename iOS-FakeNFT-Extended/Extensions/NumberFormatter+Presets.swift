//
//  NumberFormatter+Presets.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 28.10.2026.
//

import Foundation

extension NumberFormatter {
    static let ethCompactFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.positiveSuffix = " ETH"
        
        return formatter
    }()
}
