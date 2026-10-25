//
//  ShimmerPlaceholderView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 24.10.2026.
//

import SwiftUI

struct ShimmerPlaceholderView: View {
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.imagePlaceholderBackground
                
                LinearGradient(
                    colors: [
                        .clear,
                        .imagePlaceholderHighlight,
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(
                    x: isAnimating ? geometry.size.width : -geometry.size.width
                )
            }
            .compositingGroup()
            .clipped()
            .onAppear {
                withAnimation(
                    .linear(duration: 3.0)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
        }
    }
}


#Preview {
    ZStack {
        Color.ypWhite.ignoresSafeArea()
        
        ShimmerPlaceholderView()
            .frame(width: 300, height: 140)
    }
}
