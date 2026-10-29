//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-28.
//
import Foundation
import SwiftUI
import Kingfisher

@Observable
final class ProfileViewModel {
    private var profileModel: ProfileModel = ProfileModel.mock
    private var newProfileModel = ProfileModel.empty
    
    var image: UIImage?
    var isImageLoading = false
    
    func getImage() -> Image {
        profileModel.image
    }
    
    func getName() -> String {
        profileModel.name
    }
    
    func getDescription() -> String {
        profileModel.description
    }
    
    func getWebsite() -> String {
        profileModel.website
    }
    
    
}

extension ProfileViewModel {
    func save(image: Image, name: String, description: String, website: String) {
        let model = ProfileModel(
            image: image,
            name: name,
            description: description,
            website: website
        )
        profileModel = model
    }
    
    func loadImage(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        isImageLoading = true
        
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let value):
                self.image = value.image
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.isImageLoading = false
        }
    }
}
