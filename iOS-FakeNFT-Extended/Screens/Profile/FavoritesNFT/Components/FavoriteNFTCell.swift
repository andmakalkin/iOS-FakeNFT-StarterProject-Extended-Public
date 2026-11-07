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
                    Spacer()
                }
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(star <= nft.rating ? .starActive12 : .starNoActive12)
                            .resizable()
                            .frame(width: 12, height: 12)
                    }
                    Spacer()
                }
                HStack {
                    Text("\(nft.formattedPrice) ETH")
                        .font(AppFont.regular15)
                        .foregroundStyle(.ypBlack)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    let nft = Nft(createdAt: "", name: "Kitty", images: [URL(string: "https://i.pinimg.com/1200x/d3/49/1b/d3491b2125cd256caeb793aa8b9fa748.jpg")!], rating: 5, description: "", price: 100, author: "pin", website: "", id: "1")
    let model = MyNFTModel(nft: nft)
    FavoriteNFTCell(nft: model) {
        
    }
}
