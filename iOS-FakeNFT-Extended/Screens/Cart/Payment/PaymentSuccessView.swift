//
//  PaymentSuccessView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//

import SwiftUI

struct PaymentSuccessView: View {
    var cartViewModel: CartViewModel
    var onReturnToCart: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image(.successPayment)
                .font(.system(size: 150))
                .foregroundColor(.ypBlack)
            
            Text("Успех! Оплата прошла,\nпоздравляем с покупкой!")
                .font(AppFont.bold22)
                .foregroundColor(Color.ypBlack)
                .multilineTextAlignment(.center)
                .padding(.top, 36)
            
            Spacer()
            
            Button {
                cartViewModel.cartNfts = []
                cartViewModel.state = .empty
                onReturnToCart()
            } label: {
                Text("Вернуться в корзину")
                    .font(AppFont.bold17)
                    .foregroundColor(Color.ypWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.ypBlack)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.ypWhite)
        .navigationBarBackButtonHidden(true)
    }
}
