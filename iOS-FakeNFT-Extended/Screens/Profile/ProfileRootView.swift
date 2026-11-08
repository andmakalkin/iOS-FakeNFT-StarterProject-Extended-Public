//
//  ProfileRootView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-08.
//

import SwiftUI

struct ProfileRootView: View {

    var body: some View {
        ProfileView(viewModel: makeViewModel())
    }

    private func makeViewModel() -> ProfileViewModel {
        let client = DefaultNetworkClient()
        let assembly = ServicesAssembly(
            networkClient: client,
            nftStorage: NftStorageImpl()
        )

        return ProfileViewModel(assembly: assembly)
    }
}
