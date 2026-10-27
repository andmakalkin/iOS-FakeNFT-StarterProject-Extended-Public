import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TestCatalogView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .tag(0)
                .backgroundStyle(.background)
            
            CartView()
                .tabItem {
                    VStack {
                        Image(selectedTab == 1 ? .tabBarBasketActive30 : .tabBarBasket30)
                        Text("Корзина")
                    }
                }
                .tag(1)
                .backgroundStyle(.background)
        }
        .tint(.ypUniversalBlue)
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(Color.ypWhite)
        }
    }
}

