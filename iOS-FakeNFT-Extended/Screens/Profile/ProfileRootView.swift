//
//  ProfileRootView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-08.
//

import SwiftUI

struct ProfileRootView: View {
    
    @Environment(ServicesAssembly.self)
    private var services

    var body: some View {
        ProfileView(viewModel: ProfileViewModel(assembly: services))
    }
}
