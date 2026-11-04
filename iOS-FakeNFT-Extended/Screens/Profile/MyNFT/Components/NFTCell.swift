//
//  NFTCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-01.
//

import SwiftUI
import Kingfisher

struct NFTCell: View {
    let nft: MyNFTModel
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack(alignment: .topTrailing) {
                KFImage(nft.image)
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .frame(width: 108, height: 108)
                    .mask {
                        RoundedRectangle(cornerRadius: 12)
                    }
                Image(nft.isLiked ? .favoritesActive40 : .favoritesNoActive40)
            }
            HStack {
                VStack(spacing: 4) {
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
                        Text("от \(nft.author)")
                            .font(AppFont.regular13)
                            .foregroundStyle(.ypBlack)
                        Spacer()
                    }
                }
                VStack(spacing: 2) {
                    HStack {
                        Text("Цена")
                            .font(AppFont.regular13)
                            .foregroundStyle(.ypBlack)
                        Spacer()
                    }
                    HStack {
                        Text("\(nft.formattedPrice) ETH")
                            .font(AppFont.bold17)
                        Spacer()
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    let nft = Nft(createdAt: "", name: "Kitty", images: [URL(string: "https://i.pinimg.com/1200x/d3/49/1b/d3491b2125cd256caeb793aa8b9fa748.jpg")!], rating: 5, description: "", price: 100, author: "pin", website: "", id: "1")
    let model = MyNFTModel(nft: nft)
    NFTCell(nft: model)
        .padding()
}
