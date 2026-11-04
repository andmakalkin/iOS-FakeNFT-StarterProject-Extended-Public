//
//  WKWebViewRepresentable.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 04.11.2026.
//

import SwiftUI
import WebKit

struct WKWebViewRepresentable: UIViewRepresentable {
    let url: URL

    let onStartLoading: () -> Void
    let onFinishLoading: () -> Void
    let onFailLoading: (Error) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(
            onStartLoading: onStartLoading,
            onFinishLoading: onFinishLoading,
            onFailLoading: onFailLoading
        )
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        let request = URLRequest(url: url)
        webView.load(request)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }
}

// MARK: - Coordinator

extension WKWebViewRepresentable {
    final class Coordinator: NSObject, WKNavigationDelegate {
        private let onStartLoading: () -> Void
        private let onFinishLoading: () -> Void
        private let onFailLoading: (Error) -> Void

        init(
            onStartLoading: @escaping () -> Void,
            onFinishLoading: @escaping () -> Void,
            onFailLoading: @escaping (Error) -> Void
        ) {
            self.onStartLoading = onStartLoading
            self.onFinishLoading = onFinishLoading
            self.onFailLoading = onFailLoading
        }

        func webView(
            _ webView: WKWebView,
            didStartProvisionalNavigation navigation: WKNavigation?
        ) {
            onStartLoading()
        }

        func webView(
            _ webView: WKWebView,
            didFinish navigation: WKNavigation?
        ) {
            onFinishLoading()
        }

        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation?,
            withError error: Error
        ) {
            onFailLoading(error)
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation?,
            withError error: Error
        ) {
            onFailLoading(error)
        }
    }
}
