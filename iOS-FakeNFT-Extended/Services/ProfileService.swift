//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

protocol ProfileServiceProtocol: Sendable {
    func loadProfile() async throws -> Profile

    func updateProfile(
        name: String?,
        description: String?,
        avatar: String?,
        website: String?,
        likes: [String]?
    ) async throws -> Profile
}

actor ProfileService: ProfileServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadProfile() async throws -> Profile {
        let request = ProfileRequest()
        
        return try await networkClient.send(request: request)
    }
    
    func updateProfile(
        name: String? = nil,
        description: String? = nil,
        avatar: String? = nil,
        website: String? = nil,
        likes: [String]? = nil
    ) async throws -> Profile {
        let request = UpdateProfileRequest(
            name: name,
            description: description,
            avatar: avatar,
            website: website,
            likes: likes
        )
        
        return try await networkClient.send(request: request)
    }
}
