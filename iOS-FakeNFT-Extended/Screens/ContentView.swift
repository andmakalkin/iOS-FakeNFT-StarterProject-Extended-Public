import SwiftUI

struct ContentView: View {
    let assembly = ServicesAssembly(networkClient: MockNetworkClient(), nftStorage: NftStorageImpl())
    var body: some View {
        ProfileView(viewModel: ProfileViewModel(profileService: assembly.profileService), myNftViewModel: MyNFTViewModel(nftService: assembly.nftService))
    }
}
