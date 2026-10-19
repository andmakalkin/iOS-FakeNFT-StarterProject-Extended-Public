import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
        }
    }
}
