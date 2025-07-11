//
//  NewsListView.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//


import SwiftUI

struct NewsListView: View {
    @StateObject private var viewModel = NewsListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.groupedArticles.isEmpty {
                                 Text("No articles available.\nPlease sync the app.")
                                     .multilineTextAlignment(.center)
                                     .padding()
                             }
                else {
                    List {
                        ForEach(viewModel.groupedAuthors, id: \.self) { author in
                            Section(header: Text(author)
                                .font(.headline)
                                .foregroundColor(.blue)) {
                                    
                                    ForEach(viewModel.groupedArticles[author] ?? []) { article in
                                        let isSelected = viewModel.selectedArticles.contains(article.id ?? "")
                                        let isApproved = viewModel.isArticleApprovedByCurrentUser(article)
                                        
                                        HStack {
                                            // Checkbox
                                            let checkboxImageName = isSelected ? "checkmark.square.fill" : "square"
                                            Image(systemName: checkboxImageName)
                                                .foregroundColor(isApproved ? .gray : .blue)
                                                .onTapGesture {
                                                    if !isApproved {
                                                        let newSelectionState = !isSelected
                                                        viewModel.toggleSelection(for: article, isSelected: newSelectionState)
                                                    }
                                                }
                                            
                                            // Two-line Description
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(article.title ?? "Untitled")
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                
                                                Text(article.descriptionText ?? "")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(2)
                                            }
                                            .onTapGesture {
                                                // Navigate to detail view
                                                viewModel.openedArticle = article
                                            }
                                        }
                                        .contentShape(Rectangle()) // Make entire row tappable
                                        .disabled(isApproved) // Disable row if already approved
                                        .opacity(isApproved ? 0.5 : 1.0) // Dim approved rows
                                    }

                                    
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                
                Button(action: {
                                   viewModel.markApprove()
                               }) {
                                   Text("Mark Approve")
                                       .frame(maxWidth: .infinity, minHeight: 50)
                                       .background(Color.blue)
                                       .foregroundColor(.white)
                                       .cornerRadius(10)
                                       .padding(.horizontal)
                               }
                               .padding(.vertical, 10)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Notice"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.fetchArticles()
        }
        .sheet(item: $viewModel.openedArticle) { article in
                   ArticleDetailView(article: article)
               }
    }
}

