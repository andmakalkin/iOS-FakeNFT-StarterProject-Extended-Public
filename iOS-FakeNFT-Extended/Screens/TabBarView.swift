import SwiftUI

struct TabBarView: View {

    var body: some View {
        TabView {
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
