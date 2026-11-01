import SwiftUI

struct ContentView: View {
    @Environment(ServicesAssembly.self) private var services

    var body: some View {
        NavigationStack {
            CollectionView(
                collectionId: "1",
                collectionService: services.collectionService,
                nftService: services.nftService,
                orderService: services.orderService,
                profileService: services.profileService,
                userService: services.userService
            )
        }
    }
}
