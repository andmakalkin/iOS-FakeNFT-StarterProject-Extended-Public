//
//  CartItemCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import SwiftUI

struct CartItemCell: View {
    let nft: Nft
    let onDeleteAction: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            let imageString = nft.images.first?.absoluteString ?? ""
            
            if imageString.hasPrefix("http"), let imageUrl = nft.images.first {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .ypBlack))
                }
                .frame(width: 108, height: 108)
                .cornerRadius(12)
                .clipped()
                .padding(.leading, 16)
            } else {
                Image(imageString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 108, height: 108)
                    .cornerRadius(12)
                    .clipped()
                    .padding(.leading, 16)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(nft.name)
                    .font(AppFont.bold17)
                    .foregroundColor(Color.ypBlack)
                    .lineLimit(1)
                
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(star <= nft.rating ? .starActive12 : .starNoActive12)
                    }
                }
                .padding(.top, 4)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Цена")
                        .font(AppFont.regular13)
                        .foregroundColor(Color.ypBlack)
                    
                    Text(nft.price.ethFormatted)
                        .font(AppFont.bold17)
                        .foregroundColor(Color.ypBlack)
                }
                .padding(.top, 12)
            }
            .padding(.leading, 20)
            .padding(.vertical, 8)
            
            Spacer()
            
            Button(action: onDeleteAction) {
                Image(.cartDelete40)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 16)
        }
        .frame(height: 140)
        .background(Color.ypWhite)
    }
}
