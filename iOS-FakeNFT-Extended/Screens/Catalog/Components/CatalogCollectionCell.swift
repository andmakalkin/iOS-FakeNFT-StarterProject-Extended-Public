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
                .placeholder {
                    ShimmerPlaceholderView()
                }
                .onFailureView {
                    ZStack {
                        Color.imagePlaceholderBackground
                        Image(.imageStub)
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.8)
                    }
                    .frame(height: 140, alignment: .center)
                }
                .cancelOnDisappear(true)
                .fade(duration: 0.3)
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
    ZStack {
        Color.ypWhite.ignoresSafeArea()
        
        CatalogCollectionCell(
            title: "Peach",
            count: 11,
            imageURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Peach.png")
        )
        .padding(.horizontal, 16)
    }
}
