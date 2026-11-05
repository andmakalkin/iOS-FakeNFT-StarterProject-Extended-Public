//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 22.10.2026.
//

import SwiftUI

struct CatalogView: View {
    @Environment(AppRouter.self) private var router

    @State private var viewModel: CatalogViewModel
    @State private var isSortDialogPresented = false

    private var isErrorAlertPresented: Binding<Bool> {
        Binding(
            get: {
                switch viewModel.state {
                case .failedFirstPage, .failedNextPage:
                    true
                default:
                    false
                }
            },
            set: { _ in }
        )
    }

    init(
        collectionService: CollectionServiceProtocol,
        userDefaultsService: UserDefaultsServiceProtocol
    ) {
        _viewModel = State(
            initialValue: CatalogViewModel(
                collectionService: collectionService,
                userDefaultsService: userDefaultsService
            )
        )
    }

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .initial, .loadingFirstPage:
                ProgressView()

            case .loaded, .loadingNextPage, .failedNextPage:
                catalogList

            case .failedFirstPage:
                EmptyView()

            case .failedFirstPageDismissed:
                firstPageErrorView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.ypWhite
                .ignoresSafeArea()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isSortDialogPresented = true
                } label: {
                    Image(.sort42)
                        .renderingMode(.template)
                        .foregroundStyle(.ypBlack)
                }
            }
        }
        .confirmationDialog(
            "Catalog.sort.title",
            isPresented: $isSortDialogPresented,
            titleVisibility: .visible,
        ) {
            Button("Catalog.sort.byName") {
                Task {
                    await viewModel.handleSortByName()
                }
            }

            Button("Catalog.sort.byNftCount") {
                Task {
                    await viewModel.handleSortByNftCount()
                }
            }

            Button("Catalog.sort.close", role: .cancel) {}
        }
        .alert(
            "Error.loadingData",
            isPresented: isErrorAlertPresented
        ) {
            Button("Error.cancel", role: .cancel) {
                viewModel.dismissError()
            }

            Button("Error.repeat") {
                Task {
                    await viewModel.retryLoading()
                }
            }
        }
        .task {
            await viewModel.loadInitialPageIfNeeded()
        }
    }

    private var catalogList: some View {
        List {
            ForEach(viewModel.collections) { collection in
                Button {
                    router.pushToCatalog(.collection(collection.id))
                } label: {
                    CatalogCollectionCell(
                        title: collection.name,
                        count: collection.uniqueNftCount,
                        imageURL: collection.coverURL
                    )
                }
                .buttonStyle(.plain)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(.zero))
            }

            paginationFooter
                .task {
                    await viewModel.loadNextPage()
                }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listRowSpacing(8)
        .contentMargins(.top, 20, for: .scrollContent)
        .padding(.horizontal, 16)
    }

    private var firstPageErrorView: some View {
        VStack(spacing: 8) {
            Text("Error.loadingData")
                .font(AppFont.regular17)
                .foregroundStyle(.ypBlack)

            Button {
                Task {
                    await viewModel.retryLoading()
                }
            } label: {
                Text("Error.repeat")
                    .font(AppFont.regular20)
                    .foregroundStyle(.ypUniversalBlue)
            }
            .buttonStyle(.plain)
        }
    }

    private var paginationFooter: some View {
        ZStack {
            Color.clear

            if case .loadingNextPage = viewModel.state {
                ProgressView()
            }
        }
        .frame(height: 44)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(.zero))
    }
}

#Preview {
    NavigationStack {
        CatalogView(
            collectionService: CollectionService(
                networkClient: MockNetworkClient()
            ),
            userDefaultsService: UserDefaultsService()
        )
    }
    .environment(AppRouter())
}
