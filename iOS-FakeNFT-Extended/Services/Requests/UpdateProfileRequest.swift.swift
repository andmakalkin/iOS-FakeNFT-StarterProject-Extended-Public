//
//  UpdateProfileRequest.swift.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-29.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    let name: String
    let avatar: String
    let description: String
    let website: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Encodable? {
        UpdateProfileDTO(
            name: name,
            avatar: avatar,
            description: description,
            website: website
        )
    }
}

private struct UpdateProfileDTO: Encodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
}
