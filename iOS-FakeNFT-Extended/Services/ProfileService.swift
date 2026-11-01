//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

protocol ProfileServiceProtocol: Sendable {
    func loadProfile() async throws -> Profile
    func updateLikes(_ likes: [String]) async throws -> Profile
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

    func updateLikes(_ likes: [String]) async throws -> Profile {
        let request = UpdateProfileRequest(likes: likes)
        
        return try await networkClient.send(request: request)
    }
}
