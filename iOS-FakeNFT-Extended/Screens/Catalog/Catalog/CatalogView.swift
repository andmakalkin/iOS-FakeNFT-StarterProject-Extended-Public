//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 22.10.2026.
//

import SwiftUI

struct CatalogView: View {
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
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.collections) { collection in
                        CatalogCollectionCell(
                            title: collection.name,
                            count: collection.nfts.count,
                            imageURL: collection.coverURL
                        )
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
                .padding(.top, 20)
                .padding(.horizontal, 16)

                if case .loadingFirstPage = viewModel.state {
                    ProgressView()
                }
            }
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
                actions: {
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
            )
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
                await viewModel.loadFirstPage()
            }
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
    CatalogView(
        collectionService: CollectionService(networkClient: MockNetworkClient()),
        userDefaultsService: UserDefaultsService()
    )
}
