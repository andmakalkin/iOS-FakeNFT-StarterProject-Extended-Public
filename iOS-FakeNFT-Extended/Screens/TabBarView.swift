import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var services
    
    var body: some View {
        TabView {
            CatalogView(
                collectionService: services.collectionService,
                userDefaultsService: services.userDefaultsService
            )
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
