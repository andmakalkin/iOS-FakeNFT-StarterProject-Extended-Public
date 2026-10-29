//
//  MockNetworkClient.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-29.
//

import Foundation

actor MockNetworkClient: NetworkClient {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private var currentProfile: Profile?

    func send(request: NetworkRequest) async throws -> Data {
        guard let endpoint = request.endpoint else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }

        try await Task.sleep(for: .seconds(1))

        switch (request.httpMethod, endpoint.path) {
        case (.get, let path) where path.hasPrefix("/api/v1/users/"):
            return try await loadProfile()

        case (.put, "/api/v1/profile/1"):
            return try await updateProfile(request: request)

        default:
            throw NetworkClientError.incorrectRequest(
                "Mock response not found for \(request.httpMethod.rawValue) \(endpoint.path)"
            )
        }
    }

    func send<T: Decodable>(
        request: NetworkRequest
    ) async throws -> T {
        let data = try await send(request: request)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkClientError.parsingError
        }
    }

    private func loadProfile() async throws -> Data {
        if let currentProfile {
            return try encoder.encode(currentProfile)
        }

        guard let fileURL = Bundle.main.url(
            forResource: "mockProfile",
            withExtension: "json"
        ) else {
            throw NetworkClientError.incorrectRequest(
                "mockProfile.json not found"
            )
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let profile = try decoder.decode(Profile.self, from: data)

            currentProfile = profile

            return data
        } catch {
            throw NetworkClientError.parsingError
        }
    }

    private func updateProfile(
        request: NetworkRequest
    ) async throws -> Data {
        guard let dto = request.dto else {
            throw NetworkClientError.incorrectRequest(
                "Missing profile update data"
            )
        }

        let updateData: Data

        do {
            updateData = try encoder.encode(AnyEncodable(dto))
        } catch {
            throw NetworkClientError.incorrectRequest(
                "Could not encode profile update data"
            )
        }

        struct ProfileUpdate: Decodable {
            let name: String
            let avatar: String
            let description: String
            let website: String
        }

        let update: ProfileUpdate

        do {
            update = try decoder.decode(
                ProfileUpdate.self,
                from: updateData
            )
        } catch {
            throw NetworkClientError.parsingError
        }

        if currentProfile == nil {
            let profileData = try await loadProfile()
            currentProfile = try decoder.decode(
                Profile.self,
                from: profileData
            )
        }

        guard let profile = currentProfile else {
            throw NetworkClientError.incorrectRequest(
                "Profile not found"
            )
        }

        let updatedProfile = Profile(
            name: update.name,
            avatar: update.avatar,
            description: update.description,
            website: update.website,
            nfts: profile.nfts,
            rating: profile.rating,
            id: profile.id
        )

        currentProfile = updatedProfile

        return try encoder.encode(updatedProfile)
    }
}

private struct AnyEncodable: Encodable {
    private let encodeValue: (Encoder) throws -> Void

    init(_ value: Encodable) {
        encodeValue = value.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeValue(encoder)
    }
}
