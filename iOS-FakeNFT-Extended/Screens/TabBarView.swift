import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            TestCatalogView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .backgroundStyle(.background)
            
            
            CartView()
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

