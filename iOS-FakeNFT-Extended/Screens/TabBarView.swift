import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var services

    var body: some View {
        TabView {
            ProfileRootView()
                .tabItem {
                    Label(
                        String(localized: .tabProfile),
                        image: .tabBarProfile30
                    )
                }

            CatalogRootView()
                .tabItem {
                    Label(
                        String(localized: .tabCatalog),
                        image: .tabBarCatalog30
                    )
                }

            CartView(cartService: services.cartService)
                .tabItem {
                    Label(
                        String(localized: .tabCart),
                        image: .tabBarBasket30
                    )
                }
        }
    }
}

