//
//  UpdateProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    let name: String
    let description: String?
    let avatar: String?
    let website: String?
    let likes: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var bodyParameters: [URLQueryItem]? {
        var parameters = [
            URLQueryItem(name: "name", value: name)
        ]

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

        let likeParameters = likes.map {
            URLQueryItem(name: "likes", value: $0)
        }

        return parameters + likeParameters
    }
}
