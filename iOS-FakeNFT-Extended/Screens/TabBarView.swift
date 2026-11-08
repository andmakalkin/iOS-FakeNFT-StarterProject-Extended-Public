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
                .backgroundStyle(.background)
            CatalogRootView()
                .tabItem {
                    Label(
                        "Tab.catalog",
                        image: .tabBarCatalog30
                    )
                }
                .backgroundStyle(.background)

            CartView(cartService: services.cartService)
                .tabItem {
                    Label(
                        "Корзина",
                        image: .tabBarBasket30
                    )
                }
                .backgroundStyle(.background)
        }
        
    }
}

