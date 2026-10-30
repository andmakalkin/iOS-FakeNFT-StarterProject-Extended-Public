//
//  CollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 30.10.2026.
//

import SwiftUI

struct CollectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel = CollectionViewModel()
    
    var body: some View {
        ScrollView {
            coverView
                .frame(height: 310)
                .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 0) {
                titleView
                    .frame(minHeight: 28)
                    .padding(.bottom, 8)
                
                authorView
                    .frame(minHeight: 28)
                
                if viewModel.collection.description != nil {
                    descriptionView
                        .padding(.bottom, 24)
                }
            }
            .padding(.horizontal, 16)
        }
        .ignoresSafeArea()
        .scrollIndicators(.hidden)
        .background(.ypWhite)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
    }
    
    private var coverView: some View {
        Image(viewModel.collection.cover ?? "")
            .resizable()
            .scaledToFill()
            .clipShape(
                UnevenRoundedRectangle(
                    cornerRadii:
                        RectangleCornerRadii(
                            bottomLeading: 12,
                            bottomTrailing: 12
                        )
                )
            )
    }
    
    private var titleView: some View {
        HStack(spacing: 0) {
            Text(viewModel.collection.name)
                .font(AppFont.bold22)
                .tracking(0.35)
                .foregroundStyle(.ypBlack)
            
            Spacer()
        }
    }
    
    private var authorView: some View {
        HStack(spacing: 4) {
            Text("Collection.author")
                .font(AppFont.regular13)
                .tracking(-0.08)
                .foregroundStyle(.ypBlack)
            
            Text(viewModel.collection.author ?? "—")
                .font(AppFont.regular15)
                .tracking(-0.24)
                .foregroundStyle(.ypUniversalBlue)
            
            Spacer()
        }
    }
    
    private var descriptionView: some View {
        HStack(spacing: 0) {
            Text(viewModel.collection.description ?? "")
                .font(AppFont.regular13)
                .tracking(-0.08)
                .foregroundStyle(.ypBlack)
            
            Spacer()
        }
    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(.backward24)
                .renderingMode(.template)
                .foregroundStyle(.ypBlack)
                .frame(width: 24, height: 24)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        CollectionView()
    }
}
