//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-28.
//
import Foundation
import SwiftUI

@Observable
final class ProfileViewModel {
    private let profileModel: ProfileModel = ProfileModel.mock
    
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
