//
//  CartDeleteConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import SwiftUI

struct CartDeleteConfirmationView: View {
    let imageString: String
    @Binding var isPresented: Bool
    var onDeleteAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
                .environment(\.colorScheme, .light)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                if imageString.hasPrefix("http"), let imageUrl = URL(string: imageString) {
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
                } else {
                    Image(imageString)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 108, height: 108)
                        .cornerRadius(12)
                        .clipped()
                }
                
                Text("Вы уверены, что хотите\nудалить предмет из корзины?")
                    .font(AppFont.regular13)
                    .foregroundColor(Color.ypBlack)
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                
                HStack(spacing: 8) {
                    Button {
                        withAnimation {
                            onDeleteAction()
                            isPresented = false
                        }
                    } label: {
                        Text("Удалить")
                            .font(AppFont.regular17)
                            .foregroundColor(Color.ypUniversalRed)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.ypBlack)
                            .cornerRadius(12)
                    }
                    
                    Button {
                        withAnimation {
                            isPresented = false
                        }
                    } label: {
                        Text("Вернуться")
                            .font(AppFont.regular17)
                            .foregroundColor(Color.ypWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.ypBlack)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 56)
                .padding(.top, 20)
                
                Spacer()
            }
        }
    }
}
