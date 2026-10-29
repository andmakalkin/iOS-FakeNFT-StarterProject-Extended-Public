//
//  ProfileModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-28.
//

import SwiftUI

struct ProfileModel {
    let image: Image
    let name: String
    let description: String
    let website: String
}

extension ProfileModel {
    static let mock = ProfileModel(
        image: Image(.userpickPhoto28),
        name: "Joaquin Phoenix",
        description: "Дизайнер из Казани, люблю цифровое искусство  и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт к коллаборациям.",
        website: "Joaquin Phoenix.com"
    )
    
    static let empty = ProfileModel(
        image: Image(.profilePhotoDefault70),
        name: "",
        description: "",
        website: ""
    )
}
