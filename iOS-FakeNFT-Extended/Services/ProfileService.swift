//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-29.
//

import Foundation

protocol ProfileService {
    func loadProfile(id: String) async throws -> Profile
    func updateProfile(
        name: String,
        avatar: String,
        description: String,
        website: String
    ) async throws
}

@MainActor
final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadProfile(id: String) async throws -> Profile {
        let request = ProfileRequest(userId: id)
        let profile: Profile = try await networkClient.send(request: request)
        return profile
    }
    
    func updateProfile(
        name: String,
        avatar: String,
        description: String,
        website: String
    ) async throws {
        let request = UpdateProfileRequest(
            name: name,
            avatar: avatar,
            description: description,
            website: website
        )
        
        let _: Profile = try await networkClient.send(request: request)
    }
}
