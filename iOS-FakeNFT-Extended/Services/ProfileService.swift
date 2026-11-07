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
        name: String?,
        avatar: String?,
        description: String?,
        website: String?,
        likes: [String]?
    ) async throws -> Profile
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
        name: String? = nil,
        avatar: String? = nil,
        description: String? = nil,
        website: String? = nil,
        likes: [String]? = nil
    ) async throws -> Profile {

        let updatedLikes = likes?.isEmpty == true ? ["null"] : likes

        let request = UpdateProfileRequest(
            name: name,
            description: description,
            avatar: avatar,
            website: website,
            likes: updatedLikes
        )

        let updatedProfile: Profile = try await networkClient.send(
            request: request
        )

        return updatedProfile
    }
}
