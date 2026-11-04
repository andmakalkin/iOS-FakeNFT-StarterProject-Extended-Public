//
//  CatalogRootView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 04.11.2026.
//

import SwiftUI

struct CatalogRootView: View {
    @Environment(ServicesAssembly.self) private var services
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        @Bindable var router = router
        
        NavigationStack(path: $router.catalogPath) {
            CatalogView(
                collectionService: services.collectionService,
                userDefaultsService: services.userDefaultsService
            )
            .navigationDestination(for: AppRoute.self) { route in
                destination(for: route)
            }
            .sheet(item: $router.presentedModal) { route in
                if case .nft(let nftId) = route {
                    NftDetailBridgeView(nftId: nftId)
                }
            }
        }
    }
    
    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .collection(let collectionId):
            CollectionView(
                collectionId: collectionId,
                collectionService: services.collectionService,
                nftService: services.nftService,
                orderService: services.orderService,
                profileService: services.profileService,
                userService: services.userService
            )
            .toolbar(.hidden, for: .tabBar)
            
        case .webView(let url):
            WebView(url: url)
                .toolbar(.hidden, for: .tabBar)
        
        case .nft(_):
            EmptyView()
        }
    }
}
