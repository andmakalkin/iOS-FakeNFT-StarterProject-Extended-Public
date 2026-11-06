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
    var profileModel: Profile?

    private var newProfileModel = ProfileModel.empty
    
    let website = "https://www.pinterest.com"
    
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
    
    var getName: String {
        profileModel?.name ?? ""
    }

    var getDescription: String {
        profileModel?.description ?? ""
    }

    var getWebsite: String {
        profileModel?.website ?? ""
    }
    
    var getProfile: Profile {
        profileModel ?? Profile(name: "", avatar: "", description: "", website: "", nfts: [], likes: [], rating: "", id: "")
    }
    
    var getNFTNumber: String {
        "(\(profileModel?.nfts.count ?? 0))"
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
                website: website,
                nfts: [],
                likes: [],
                id: "1"
            )
            
            if let currentProfile = profileModel {
                profileModel = Profile(
                    name: name,
                    avatar: avatar,
                    description: description,
                    website: website,
                    nfts: currentProfile.nfts,
                    likes: currentProfile.likes,
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
                ProgressHUD.dismiss()
            case .failure(let error):
                print(error.localizedDescription)
                ProgressHUD.dismiss()
            }
        }
    }
}
