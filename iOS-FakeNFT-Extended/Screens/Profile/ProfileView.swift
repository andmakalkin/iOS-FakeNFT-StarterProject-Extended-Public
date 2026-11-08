//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-27.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel: ProfileViewModel
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(value: ProfileDestination.editProfile) {
                        Image(.edit42)
                            .frame(width: 42, height: 42)
                    }
                }
                .frame(height: 42)
                .padding(EdgeInsets(top: 2, leading: 9, bottom: 0, trailing: 9))
                
                VStack(spacing: 20) {
                    HStack(spacing: 16) {
                        Image(uiImage: viewModel.image)
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                        Text(viewModel.getName)
                            .font(AppFont.bold22)
                            .tint(.ypBlack)
                        Spacer()
                        
                    }
                    .frame(height: 70)
                    HStack {
                        Text(viewModel.getDescription)
                            .font(AppFont.regular13)
                        Spacer()
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
                
                HStack {
                    NavigationLink(value: ProfileDestination.website) {
                        Text(viewModel.getWebsite)
                            .font(AppFont.regular15)
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
                
                VStack {
                    NavigationLink(value: ProfileDestination.myNFT) {
                        HStack {
                            HStack(spacing: 8) {
                                Text("Мои NFT")
                                Text(viewModel.getNFTNumber)
                            }
                            .font(AppFont.bold17)
                            
                            Spacer()
                            
                            Image(.backward24)
                                .rotationEffect(.degrees(180))
                        }
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    }
                    .tint(.ypBlack)
                    .frame(height: 54)
                    
                    NavigationLink(value: ProfileDestination.likedNFT) {
                        HStack {
                            HStack(spacing: 8) {
                                Text("Избранные NFT")
                                Text(viewModel.getFavNFTNumber)
                            }
                            .font(AppFont.bold17)
                            
                            Spacer()
                            
                            Image(.backward24)
                                .rotationEffect(.degrees(180))
                        }
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    }
                    .tint(.ypBlack)
                    .frame(height: 54)
                }
                .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
                
                Spacer()
            }
            .navigationDestination(for: ProfileDestination.self) { destination in
                switch destination {
                case .editProfile:
                    EditProfileView(viewModel: $viewModel)
                case .myNFT:
                    MyNFTView(viewModel: MyNFTViewModel(assembly: viewModel.assembly, profileModel: viewModel.getProfile), profile: viewModel.getProfile)
                case .likedNFT:
                    FavoritesNFTView(viewModel: FavoritesNFTViewModel(assembly: viewModel.assembly, profileModel: viewModel.getProfile))
                case .website:
                    WebView(url: URL(string: viewModel.website)!)
                }
            }
            .task {
                await viewModel.loadProfile()
                viewModel.loadProfileImage()
            }
            .disabled(viewModel.profileModel == nil)
        }
    }
}

#Preview {
    let client = DefaultNetworkClient()
    let assembly = ServicesAssembly(networkClient: client, nftStorage: NftStorageImpl())
    let model = ProfileViewModel(assembly: assembly)
    ProfileView(viewModel: model)
}
