//
//  UpdateProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    let name: String?
    let description: String?
    let avatar: String?
    let website: String?
    let likes: [String]?

    init(
        name: String? = nil,
        description: String? = nil,
        avatar: String? = nil,
        website: String? = nil,
        likes: [String]? = nil
    ) {
        self.name = name
        self.description = description
        self.avatar = avatar
        self.website = website
        self.likes = likes
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var bodyParameters: [URLQueryItem]? {
        var parameters: [URLQueryItem] = []

        if let name {
            parameters.append(
                URLQueryItem(name: "name", value: name)
            )
        }

        if let description {
            parameters.append(
                URLQueryItem(name: "description", value: description)
            )
        }

        if let avatar {
            parameters.append(
                URLQueryItem(name: "avatar", value: avatar)
            )
        }

        if let website {
            parameters.append(
                URLQueryItem(name: "website", value: website)
            )
        }

        if let likes {
            if likes.isEmpty {
                parameters.append(
                    URLQueryItem(name: "likes", value: "")
                )
            } else {
                parameters.append(
                    contentsOf: likes.map {
                        URLQueryItem(name: "likes", value: $0)
                    }
                )
            }
        }

        return parameters
    }
}
