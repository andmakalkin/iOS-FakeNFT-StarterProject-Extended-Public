//
//  CartItemCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import SwiftUI

struct CartItemCell: View {
    let nft: Nft
    
    var body: some View {
        HStack(spacing: 0) {
            let imageName = nft.images.first?.absoluteString ?? ""
            
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 108, height: 108)
                .clipped()
                .cornerRadius(12)
                .padding(.leading, 16)
            
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
            
            Image(.cartDelete40)
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.trailing, 16)
        }
        .frame(height: 140)
        .background(Color.ypWhite)
    }
}


