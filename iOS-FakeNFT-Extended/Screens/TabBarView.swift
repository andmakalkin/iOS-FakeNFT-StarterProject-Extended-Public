import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var services

    var body: some View {
        TabView {
            ProfileRootView()
                .tabItem {
                    Label(
                        "Tab.profile",
                        image: .tabBarProfile30
                    )
                }

            CatalogRootView()
                .tabItem {
                    Label(
                        "Tab.catalog",
                        image: .tabBarCatalog30
                    )
                }

            CartView(cartService: services.cartService)
                .tabItem {
                    Label(
                        "Корзина",
                        image: .tabBarBasket30
                    )
                }
        }
    }
}

