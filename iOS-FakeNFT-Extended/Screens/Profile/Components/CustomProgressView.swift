//
//  CustomProgressView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-28.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.ypLightGrey)
                .frame(width: 82, height: 82)
            ProgressView()
                .frame(width: 30, height: 30)
                .scaleEffect(1.5)
        }
    }
}

#Preview {
    CustomProgressView()
}
