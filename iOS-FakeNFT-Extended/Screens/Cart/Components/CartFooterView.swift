//
//  CartFooterView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import SwiftUI

struct CartFooterView: View {
    let count: Int
    let price: Double
    let onPayTapped: () -> Void
    
    var body: some View {
        // Окрашиваем весь базовый контейнер в белый цвет, чтобы зона под таб-баром стала белой
        VStack(spacing: 0) {
            
            // Сама светло-серая панель подвала по Фигме
            VStack(spacing: 0) {
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(count) NFT")
                            .font(AppFont.regular15)
                            .foregroundColor(Color.ypBlack)
                        Text(price.ethFormatted)
                            .font(AppFont.bold17)
                            .foregroundColor(Color.ypUniversalGreen)
                    }
                    
                    Spacer()
                    
                    Button(action: onPayTapped) {
                        Text("К оплате")
                            .font(AppFont.bold17)
                            .foregroundColor(Color.ypWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.ypBlack)
                            .cornerRadius(16)
                    }
                    .frame(width: 240)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 16)
            }
            .background(Color.ypLightGrey)
            
           
            Color.ypWhite
                .frame(height: 1)
        }
        .background(Color.ypWhite)
    }
}

