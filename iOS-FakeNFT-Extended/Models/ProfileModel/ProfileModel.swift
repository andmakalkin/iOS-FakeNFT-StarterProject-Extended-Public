//
//  ProfileModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-28.
//

import SwiftUI

struct ProfileModel {
    let image: UIImage
    let name: String
    let description: String
    let website: String
}

extension ProfileModel {    
    static let empty = ProfileModel(
        image: .profilePhotoDefault70,
        name: "",
        description: "",
        website: ""
    )
}
