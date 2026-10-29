//
//  CollectionNftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 28.10.2026.
//

import SwiftUI

struct CollectionNftCell: View {
    let onTapLike: () -> Void
    let onTapCart: () -> Void
    let onTapNft: () -> Void
    
    let isLiked: Bool
    let isInCart: Bool
    
    let title: String
    let rating: Int
    let price: Double
    let imageURL: URL?
    let imageString: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(imageString)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fit)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button {
                    onTapLike()
                } label: {
                    Image(isLiked ? .favoritesActive40 : .favoritesNoActive40)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 8)
            
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { value in
                    Image(value <= rating ? .starActive12 : .starNoActive12)
                }
                
                Spacer()
            }
            .frame(height: 12)
            .padding(.bottom, 4)
            
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppFont.bold17)
                        .lineLimit(1)
                        .frame(minHeight: 22)
                    
                    Text(
                        NumberFormatter.ethCompactFormatter
                            .string(from: NSNumber(value: price)) ?? "\(price) ETH"
                    )
                    .font(AppFont.medium10)
                    .tracking(-0.24)
                    .frame(minHeight: 12)
                }
                .foregroundStyle(.ypBlack)
                
                Spacer()
                
                Button {
                    onTapCart()
                } label: {
                    Image(isInCart ? .cartDelete40 : .cartAdd40)
                        .renderingMode(.template)
                        .foregroundStyle(.ypBlack)
                }
                .buttonStyle(.plain)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTapNft()
        }
    }
}

#Preview {
    CollectionNftCell(
        onTapLike: {},
        onTapCart: {},
        onTapNft: {},
        isLiked: true,
        isInCart: true,
        title: "Archie",
        rating: 3,
        price: 1.78,
        imageURL: nil,
        imageString: "nft1"
    )
    .background(.ypWhite)
    .frame(width: 108)
}
