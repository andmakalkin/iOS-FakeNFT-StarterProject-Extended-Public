import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            CatalogView()
                .tabItem {
                    Label(
                        "Tab.catalog",
                        image: "tabBarCatalog30"
                    )
                }
                .backgroundStyle(.background)
        }
    }
}
