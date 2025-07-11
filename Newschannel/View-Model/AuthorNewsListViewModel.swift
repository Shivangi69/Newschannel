//
//  AuthorNewsListViewModel.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//


import SwiftUI
import CoreData

class AuthorNewsListViewModel: ObservableObject {
    @Published var authorArticles: [ArticleMetadata] = []
    @Published var openedArticle: ArticleMetadata?
    
    private let context = PersistenceController.shared.container.viewContext
    private let sessionManager = UserSessionManager()
    
    func fetchAuthorArticles() {
        guard let currentUser = sessionManager.getUser() else {
            print("❌ No user logged in")
            return
        }
        
        let fetchRequest: NSFetchRequest<ArticleMetadata> = ArticleMetadata.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "author == %@", currentUser.username)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ArticleMetadata.title, ascending: true)]
        
        do {
            authorArticles = try context.fetch(fetchRequest)
            print("✅ Fetched \(authorArticles.count) articles for author \(currentUser.username)")
        } catch {
            print("❌ Failed to fetch articles: \(error.localizedDescription)")
        }
    }
}
