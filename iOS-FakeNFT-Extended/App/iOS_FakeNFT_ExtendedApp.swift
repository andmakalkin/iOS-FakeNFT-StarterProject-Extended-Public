import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    init() {
        Self.configureTabBarAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    ServicesAssembly(
                        networkClient: DefaultNetworkClient(),
                        nftStorage: NftStorageImpl()
                    )
                )
                .environment(AppRouter())
        }
    }

    private static func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypWhite
        appearance.shadowColor = .clear

        let itemAppearance = appearance.stackedLayoutAppearance

        itemAppearance.selected.iconColor = .ypUniversalBlue
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.ypUniversalBlue
        ]

        itemAppearance.normal.iconColor = .ypBlack
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.ypBlack
        ]

        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
