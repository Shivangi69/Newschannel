//
//  ArticleDetailView.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//


import SwiftUI

struct ArticleDetailView: View {
    let article: ArticleMetadata
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(article.title ?? "Untitled")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)
                
                // Author
                Text("By \(article.author ?? "Unknown Author")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                // Full Content
                Text(article.detail?.fullContent ?? "No content available.")
                    .font(.body)
                    .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("Article Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
