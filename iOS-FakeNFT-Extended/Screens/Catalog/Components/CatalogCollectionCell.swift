//
//  CatalogCollectionCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 22.10.2026.
//

import SwiftUI
import Kingfisher

struct CatalogCollectionCell: View {
    let title: String
    let count: Int
    let imageURL: URL?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            KFImage(imageURL)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 140, alignment: .top)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            HStack(spacing: 4) {
                Text(title)
                Text("(\(count))")
            }
            .font(AppFont.bold17)
            .foregroundStyle(.ypBlack)
            .lineLimit(1)
            .frame(height: 22)
        }
        .padding(.bottom, 13)
    }
}

#Preview {
    let cache = ImageCache.default
    cache.clearMemoryCache()
    cache.clearDiskCache()
    
    return CatalogCollectionCell(
        title: "Peach",
        count: 11,
        imageURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Peach.png")
    )
    .padding(.horizontal, 16)
}
