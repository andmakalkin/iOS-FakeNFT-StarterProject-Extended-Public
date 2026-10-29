//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-27.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel(profileService: ProfileServiceImpl(networkClient: MockNetworkClient()))
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(value: ProfileDestionation.editProfile) {
                        Image(.edit42)
                            .frame(width: 42, height: 42)
                    }
                }
                .frame(height: 42)
                .padding(EdgeInsets(top: 2, leading: 9, bottom: 0, trailing: 9))
                
                VStack(spacing: 20) {
                    HStack(spacing: 16) {
                        Image(uiImage: viewModel.getImage())
                            .resizable()
                            .frame(width: 70, height: 70)
                        Text(viewModel.getName())
                            .font(.system(size: 22, weight: .bold))
                            .tint(.ypBlack)
                        Spacer()
                        
                    }
                    .frame(height: 70)
                    HStack {
                        Text(viewModel.getDescription())
                            .font(.system(size: 13))
                        Spacer()
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
                
                HStack {
                    Button {
                        
                    } label: {
                        Text(viewModel.getWebsite())
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
                
                VStack {
                    NavigationLink(value: ProfileDestionation.myNFT) {
                        HStack {
                            HStack(spacing: 8) {
                                Text("Мои NFT")
                                Text("(112)")
                            }
                            .font(.system(size: 17, weight: .bold))
                            
                            Spacer()
                            
                            Image(.backward24)
                                .rotationEffect(.degrees(180))
                        }
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    }
                    .tint(.ypBlack)
                    .frame(height: 54)
                    
                    NavigationLink(value: ProfileDestionation.likedNFT) {
                        HStack {
                            HStack(spacing: 8) {
                                Text("Избранные NFT")
                                Text("(11)")
                            }
                            .font(.system(size: 17, weight: .bold))
                            
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
            .navigationDestination(for: ProfileDestionation.self) { destionation in
                switch destionation {
                case .editProfile:
                    EditProfileView(viewModel: $viewModel)
                case .myNFT:
                    EmptyView()
                case .likedNFT:
                    EmptyView()
                }
            }
            .task {
                await viewModel.loadProfile()
            }
        }
    }
}

#Preview {
    ProfileView()
}
