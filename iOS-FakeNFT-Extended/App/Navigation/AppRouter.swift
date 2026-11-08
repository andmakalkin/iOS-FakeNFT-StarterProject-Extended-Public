//
//  AppRouter.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 04.11.2026.
//

import Foundation

@MainActor
@Observable
final class AppRouter {
    var catalogPath: [AppRoute] = []
    var presentedModal: AppRoute?
    var presentedFullScreen: AppRoute?

    // MARK: - Catalog

    func pushToCatalog(_ route: AppRoute) {
        catalogPath.append(route)
    }

    func popCatalog() {
        guard !catalogPath.isEmpty else { return }

        catalogPath.removeLast()
    }

    // MARK: - Modal

    func showModal(_ route: AppRoute) {
        presentedModal = route
    }

    func showFullScreen(_ route: AppRoute) {
        presentedFullScreen = route
    }
}
