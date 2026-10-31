//
//  ProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-29.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    let userId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(userId)")
    }
}
