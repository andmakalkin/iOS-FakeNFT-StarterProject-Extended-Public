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
    enum State {
        case loading
        case loaded
        case failed(Error)
    }

    private(set) var state: State = .loading

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
}
