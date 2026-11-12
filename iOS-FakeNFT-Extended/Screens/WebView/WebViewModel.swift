//
//  WebViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 04.11.2026.
//

import Foundation
import OSLog

@MainActor
@Observable
final class WebViewModel {

    // MARK: - State

    enum State {
        case initial
        case loading
        case loaded
        case failed(Error)
    }

    let url: URL
    let title: String?

    private(set) var state: State = .loading

    // MARK: - Init

    init(url: URL, title: String? = nil) {
        self.url = url
        self.title = title
    }

    // MARK: - Public Methods

    func didStartLoading() {
        state = .loading
    }

    func didFinishLoading() {
        state = .loaded
    }

    func didFailLoading(with error: Error) {
        Logger.webView.error(
            "Не удалось загрузить WebView: \(String(describing: error), privacy: .public)"
        )

        state = .failed(error)
    }

    func retry() {
        state = .loading
    }

    func dismissError() {
        guard case .failed = state else { return }

        state = .initial
    }
}
