import SwiftUI

struct TabBarView: View {

    var body: some View {
        TabView {
            ProfileRootView()
                .tabItem {
                    Label(
                        "Tab.catalog",
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
        }
    }
}
