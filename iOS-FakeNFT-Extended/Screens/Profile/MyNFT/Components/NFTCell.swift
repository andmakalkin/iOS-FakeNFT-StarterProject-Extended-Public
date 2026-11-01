//
//  NFTCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-01.
//

import SwiftUI

struct NFTCell: View {
    var body: some View {
        HStack(spacing: 20) {
            Image(.nft1)
                .resizable()
                .frame(width: 108, height: 108)
                .mask {
                    RoundedRectangle(cornerRadius: 12)
                }
            HStack {
                VStack {
                    HStack {
                        Text("Lilo")
                            .font(.system(size: 17, weight: .bold))
                            .tint(.ypBlack)
                        Spacer()
                    }
                    
                }
            }
            Spacer()
        }
    }
}

#Preview {
    NFTCell()
        .padding()
}
