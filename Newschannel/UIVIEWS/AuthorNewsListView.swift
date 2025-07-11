//
//  AuthorNewsListView.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//

import SwiftUI

struct AuthorNewsListView: View {
    @StateObject private var viewModel = AuthorNewsListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.authorArticles.isEmpty {
                    Text("No articles found.\nPlease sync the app.")
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List(viewModel.authorArticles) { article in
                        VStack(alignment: .leading, spacing: 6) {
                            // Title and Description
                            Text(article.title ?? "Untitled")
                                .font(.headline)
                            Text(article.descriptionText ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                            
                            // Approve Count
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Approved by \(article.approveCount) reviewer(s)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 8)
                        .onTapGesture {
                            viewModel.openedArticle = article
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("My Articles")
            .sheet(item: $viewModel.openedArticle) { article in
                ArticleDetailView(article: article)
            }
            .onAppear {
                viewModel.fetchAuthorArticles()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
