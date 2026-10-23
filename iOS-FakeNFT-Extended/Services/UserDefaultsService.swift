//
//  UserDefaultsService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 23.10.2026.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func saveCatalogSortOption(_ option: CatalogSortOption)
    func fetchCatalogSortOption() -> CatalogSortOption?
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    private enum Keys: String {
        case catalogSortOption
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveCatalogSortOption(_ option: CatalogSortOption) {
        userDefaults.set(
            option.rawValue,
            forKey: Keys.catalogSortOption.rawValue
        )
    }
    
    func fetchCatalogSortOption() -> CatalogSortOption? {
        guard let rawValue = userDefaults.string(
            forKey: Keys.catalogSortOption.rawValue
        ) else {
            return nil
        }
        
        return CatalogSortOption(rawValue: rawValue)
    }
}
