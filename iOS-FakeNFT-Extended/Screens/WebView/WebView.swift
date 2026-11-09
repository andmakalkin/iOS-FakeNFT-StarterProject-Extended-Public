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
            set: { isPresented in
                if !isPresented {
                    viewModel.dismissError()
                }
            }
        )
    }

    private var isWebViewLoaded: Bool {
        if case .loaded = viewModel.state {
            return true
        }

        return false
    }

    init(url: URL, title: String? = nil) {
        _viewModel = State(
            initialValue: WebViewModel(url: url, title: title)
        )
    }

    var body: some View {
        ZStack {
            Color.ypWhite
                .ignoresSafeArea()

            switch viewModel.state {
            case .loading, .loaded:
                WKWebViewRepresentable(
                    url: viewModel.url,
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

            case .initial, .failed:
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
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

            if let title = viewModel.title {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(AppFont.bold17)
                        .foregroundStyle(.ypBlack)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
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
        string: RequestConstants.webViewStub,
    ) {
        NavigationStack {
            WebView(url: url, title: "Пользовательское соглашение")
        }
    }
}
