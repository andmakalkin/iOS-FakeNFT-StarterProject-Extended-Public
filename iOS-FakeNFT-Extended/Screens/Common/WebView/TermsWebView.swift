//
//  TermsWebView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import SwiftUI
import WebKit


struct WebViewRepresentable: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}


struct TermsWebView: View {
    let url: URL
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            WebViewRepresentable(url: url)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
