//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-28.
//
import Foundation
import SwiftUI
import Kingfisher
import ProgressHUD

@Observable
final class ProfileViewModel {
    private let profileService: ProfileService
    private var profileModel: Profile?

    private var newProfileModel = ProfileModel.empty
    
    var image: UIImage = UIImage(resource: .profilePhotoDefault70)
    
    init(profileService: ProfileService) {
        self.profileService = profileService
    }
    
    func loadProfile() async {
        do {
            profileModel = try await profileService.loadProfile(id: "1")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadProfileImage() {
        guard let profileModel else { return }
        loadImage(urlString: profileModel.avatar)
    }
    
    func getName() -> String {
        guard let profileModel else { return "" }
        return profileModel.name
    }
    
    func getDescription() -> String {
        guard let profileModel else { return "" }
        return profileModel.description
    }
    
    func getWebsite() -> String {
        guard let profileModel else { return "" }
        return profileModel.website
    }
}

extension ProfileViewModel {
    func save(
        name: String,
        avatar: String,
        description: String,
        website: String
    ) async {
        do {
            try await profileService.updateProfile(
                name: name,
                avatar: avatar,
                description: description,
                website: website
            )
            
            if let currentProfile = profileModel {
                profileModel = Profile(
                    name: name,
                    avatar: avatar,
                    description: description,
                    website: website,
                    nfts: currentProfile.nfts,
                    rating: currentProfile.rating,
                    id: currentProfile.id
                )
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadImage(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            guard let self else { return }
            
            ProgressHUD.animate()
            
            switch result {
            case .success(let value):
                self.image = value.image
                ProgressHUD.succeed()
            case .failure(let error):
                print(error.localizedDescription)
                ProgressHUD.dismiss()
            }
        }
    }
}
