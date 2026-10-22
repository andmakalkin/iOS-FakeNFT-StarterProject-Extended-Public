//
//  CatalogCollectionCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 22.10.2026.
//

import SwiftUI

struct CatalogCollectionCell: View {
    let title: String
    let count: Int
    let image: Image
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            image
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
    CatalogCollectionCell(
        title: "Peach",
        count: 11,
        image: Image(.collectionCover2)
    )
    .padding(.horizontal, 16)
}
