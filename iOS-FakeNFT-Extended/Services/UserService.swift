//
//  UserService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

protocol UserServiceProtocol: Sendable {
    func loadUser(id: String) async throws -> User
}

actor UserService: UserServiceProtocol {

    private let networkClient: NetworkClient


    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadUser(id: String) async throws -> User {
        let request = UserByIdRequest(id: id)

        return try await networkClient.send(
            request: request
        )
    }
}
