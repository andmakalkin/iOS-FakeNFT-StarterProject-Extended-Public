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
    let assembly: ServicesAssembly
    var profileModel: Profile?

    private var newProfileModel = ProfileModel.empty
    
    let website = "https://www.pinterest.com"
    
    var image: UIImage = UIImage(resource: .profilePhotoDefault70)
    
    init(assembly: ServicesAssembly) {
        self.assembly = assembly
    }
    
    func loadProfile() async {
        do {
            profileModel = try await assembly.profileService.loadProfile(id: "1")
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
        guard let currentProfile = profileModel else { return }

        let updatedName = name == currentProfile.name ? nil : name
        let updatedAvatar = avatar == currentProfile.avatar ? nil : avatar
        let updatedDescription = description == currentProfile.description ? nil : description
        let updatedWebsite = website == currentProfile.website ? nil : website

        guard updatedName != nil ||
              updatedAvatar != nil ||
              updatedDescription != nil ||
              updatedWebsite != nil else {
            return
        }

        do {
            let updatedProfile = try await assembly.profileService.updateProfile(
                name: updatedName,
                avatar: updatedAvatar,
                description: updatedDescription,
                website: updatedWebsite,
                likes: nil
            )

            profileModel = updatedProfile

        } catch {
            print(error)
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
