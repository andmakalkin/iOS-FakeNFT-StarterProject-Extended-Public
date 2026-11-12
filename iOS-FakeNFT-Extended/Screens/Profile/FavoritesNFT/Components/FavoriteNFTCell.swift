//
//  FavoriteNFTCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-07.
//

import SwiftUI
import Kingfisher

struct FavoriteNFTCell: View {
    let nft: MyNFTModel
    let onLikeTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                KFImage(nft.imageURL)
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .frame(width: 80, height: 80)
                    .mask {
                        RoundedRectangle(cornerRadius: 12)
                    }
                Button(action: onLikeTap) {
                    Image(nft.isLiked ? .favoritesActive30 : .favoritesNoActive30)
                }
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text(nft.name)
                        .font(AppFont.bold17)
                        .foregroundStyle(.ypBlack)
                        .lineLimit(1)
                    Spacer()
                }
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(star <= nft.rating ? .starActive12 : .starNoActive12)
                            .renderingMode(star <= nft.rating ? .original : .template)
                            .resizable()
                            .foregroundStyle(.ypLightGrey)
                            .frame(width: 12, height: 12)
                    }
                    Spacer()
                }
                HStack {
                    Text("\(nft.formattedPrice) ETH")
                        .font(AppFont.regular15)
                        .foregroundStyle(.ypBlack)
                        .lineLimit(1)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    let nft = Nft(id: "", images: [URL(string: "https://i.pinimg.com/1200x/d3/49/1b/d3491b2125cd256caeb793aa8b9fa748.jpg")!], name: "Kitty", rating: 5, price: 10, createdAt: nil, description: "pin", author: nil, website: nil)
    let model = MyNFTModel(nft: nft)
    FavoriteNFTCell(nft: model) {
        
    }
}
