//
//  NFTCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-01.
//

import SwiftUI

struct NFTCell: View {
    let nft: MyNFTModel
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack(alignment: .topTrailing) {
                nft.image
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
                            .font(.system(size: 17, weight: .bold))
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
                            .font(.system(size: 13))
                            .foregroundStyle(.ypBlack)
                        Spacer()
                    }
                }
                VStack(spacing: 2) {
                    HStack {
                        Text("Цена")
                            .font(.system(size: 13))
                            .foregroundStyle(.ypBlack)
                        Spacer()
                    }
                    HStack {
                        Text("\(nft.formattedPrice) ETH")
                            .font(.system(size: 17, weight: .bold))
                        Spacer()
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    let nft = MyNFTModel(id: "1", image: Image(.nft1), name: "Lilo", rating: 3, author: "John Doe", price: 1.78, isLiked: false)
    NFTCell(nft: nft)
        .padding()
}
