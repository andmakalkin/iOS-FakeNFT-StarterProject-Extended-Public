//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

protocol ProfileServiceProtocol: Sendable {
    func loadProfile() async throws -> Profile
    func toggleLike(nftId: String) async throws -> Profile
}

actor ProfileService: ProfileServiceProtocol {
    // MARK: - State

    private var cachedProfile: Profile?
    private var operationTail: Task<Void, Never>?
    private var operationGeneration = 0

    // MARK: - Dependencies

    private let networkClient: NetworkClient

    // MARK: - Init

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Actions

    func loadProfile() async throws -> Profile {
        try await performInQueue { service in
            try await service.fetchProfile()
        }
    }

    func toggleLike(nftId: String) async throws -> Profile {
        try await performInQueue { service in
            let profile = try await service.currentProfile()

            var updatedLikes = profile.likes

            if updatedLikes.contains(nftId) {
                updatedLikes.removeAll { $0 == nftId }
            } else {
                updatedLikes.append(nftId)
            }

            return try await service.updateLikes(updatedLikes)
        }
    }

    // MARK: - Profile State

    private func currentProfile() async throws -> Profile {
        if let cachedProfile {
            return cachedProfile
        }

        return try await fetchProfile()
    }

    // MARK: - Network

    private func fetchProfile() async throws -> Profile {
        let request = ProfileRequest()

        let profile: Profile = try await networkClient.send(
            request: request
        )

        cachedProfile = profile

        return profile
    }

    private func updateLikes(
        _ likes: [String]
    ) async throws -> Profile {
        let request = UpdateProfileRequest(
            likes: likes
        )

        let updatedProfile: Profile = try await networkClient.send(
            request: request
        )

        cachedProfile = updatedProfile

        return updatedProfile
    }

    // MARK: - Queue

    private func performInQueue<T: Sendable>(
        _ operation: @escaping @Sendable (
            isolated ProfileService
        ) async throws -> T
    ) async throws -> T {
        let previousOperation = operationTail

        operationGeneration += 1
        let operationId = operationGeneration

        let task = Task<T, Error> { [self] in
            if let previousOperation {
                await previousOperation.value
            }

            try Task.checkCancellation()

            return try await operation(self)
        }

        operationTail = Task<Void, Never> {
            _ = try? await task.value
        }

        defer {
            if operationId == operationGeneration {
                operationTail = nil
            }
        }

        return try await withTaskCancellationHandler {
            try await task.value
        } onCancel: {
            task.cancel()
        }
    }
}
