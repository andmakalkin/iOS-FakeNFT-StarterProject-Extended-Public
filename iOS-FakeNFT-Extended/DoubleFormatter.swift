//
//  DoubleFormatter.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//

import Foundation

extension Double {
    var ethFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return (formatter.string(from: NSNumber(value: self)) ?? "\(self)") + " ETH"
    }
}
