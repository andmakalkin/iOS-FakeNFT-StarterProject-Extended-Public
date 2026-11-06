import SwiftUI

struct ContentView: View {
    let assembly = ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl())
    var body: some View {
        ProfileView(viewModel: ProfileViewModel(assembly: assembly))
    }
}
