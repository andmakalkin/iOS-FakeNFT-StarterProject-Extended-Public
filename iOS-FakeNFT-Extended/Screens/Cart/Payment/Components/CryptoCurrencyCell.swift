//
//  CryptoCurrencyCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//

import SwiftUI

struct CryptoCurrencyCell: View {
    let currency: Currency
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            
            AsyncImage(url: currency.image) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(6)
                            default:
                                Image(currency.id, bundle: .main)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(6)
                            }
                        }
                        .frame(width: 36, height: 36)
                        .background(Color.ypBlack)
                        .cornerRadius(6)
                        .padding(.leading, 12)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(currency.title)
                    .font(AppFont.regular13)
                    .foregroundColor(.ypBlack)
                
                Text(currency.name)
                    .font(AppFont.regular13)
                    .foregroundColor(.ypUniversalGreen)
            }
            .padding(.leading, 4)
            
            Spacer()
        }
        .frame(height: 46)
        .background(Color.ypLightGrey)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.ypBlack : Color.clear, lineWidth: 1)
        )
    }
}
