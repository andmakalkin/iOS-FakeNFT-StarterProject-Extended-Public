//
//  WebView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 04.11.2026.
//

import SwiftUI

struct WebView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: WebViewModel

    private var isErrorAlertPresented: Binding<Bool> {
        Binding(
            get: {
                if case .failed = viewModel.state {
                    return true
                }

                return false
            },
            set: { _ in }
        )
    }

    private var isWebViewLoaded: Bool {
        if case .loaded = viewModel.state {
            return true
        }

        return false
    }

    private let url: URL

    init(url: URL) {
        _viewModel = State(
            initialValue: WebViewModel()
        )
        self.url = url
    }

    var body: some View {
        ZStack {
            Color.ypWhite
                .ignoresSafeArea()

            switch viewModel.state {
            case .loading, .loaded:
                WKWebViewRepresentable(
                    url: url,
                    onStartLoading: viewModel.didStartLoading,
                    onFinishLoading: viewModel.didFinishLoading,
                    onFailLoading: viewModel.didFailLoading(with:)
                )
                .ignoresSafeArea(edges: .bottom)
                .opacity(isWebViewLoaded ? 1 : 0)
                .allowsHitTesting(isWebViewLoaded)
                .overlay {
                    if case .loading = viewModel.state {
                        ProgressView()
                    }
                }

            case .failed:
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(.backward24)
                        .renderingMode(.template)
                        .foregroundStyle(.ypBlack)
                }
            }
        }
        .alert(
            "Error.loadingData",
            isPresented: isErrorAlertPresented
        ) {
            Button("Error.cancel", role: .cancel) {
                dismiss()
            }

            Button("Error.repeat") {
                viewModel.retry()
            }
        }
    }
}

#Preview {
    if let url = URL(
        string: "https://yandex.ru/legal/practicum_termsofuse"
    ) {
        NavigationStack {
            WebView(url: url)
        }
    }
}
