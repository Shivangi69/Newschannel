import SwiftUI
import CoreData

class NewsListViewModel: ObservableObject {
    @Published var groupedArticles: [String: [ArticleMetadata]] = [:]
    @Published var groupedAuthors: [String] = []
    @Published var selectedArticles: Set<String> = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var openedArticle: ArticleMetadata?

    private let context = PersistenceController.shared.container.viewContext
    let sessionManager = UserSessionManager()

    // Fetch all articles from Core Data and group by author
    func fetchArticles() {
        let fetchRequest: NSFetchRequest<ArticleMetadata> = ArticleMetadata.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ArticleMetadata.author, ascending: true)]
        
        do {
            let articles = try context.fetch(fetchRequest)
            groupArticlesByAuthor(articles)
        } catch {
            print("❌ Failed to fetch articles: \(error.localizedDescription)")
        }
    }
    
    private func groupArticlesByAuthor(_ articles: [ArticleMetadata]) {
        let grouped = Dictionary(grouping: articles) { $0.author ?? "Unknown" }
        groupedArticles = grouped
        groupedAuthors = grouped.keys.sorted()
    }
    
    // Toggle selection for checkbox
    func toggleSelection(for article: ArticleMetadata, isSelected: Bool) {
        if let id = article.id {
            if isSelected {
                selectedArticles.insert(id)
            } else {
                selectedArticles.remove(id)
            }
        }
    }
    
    // Check if current user has approved the article
    func isArticleApprovedByCurrentUser(_ article: ArticleMetadata) -> Bool {
        guard let currentUser = sessionManager.getUser() else { return false }
        
        let approvedByList: [String]
        if let jsonString = article.approvedBy,
           let data = jsonString.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            approvedByList = decoded
        } else {
            approvedByList = []
        }
        
        return approvedByList.contains(currentUser.username)
    }
    
    // Show alert
    func showAlertWith(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    // Mark selected articles as approved
//    func markApprove() {
//        guard let currentUser = sessionManager.getUser() else {
//            print("❌ No user logged in")
//            return
//        }
//        
//        guard !selectedArticles.isEmpty else {
//            showAlertWith(message: "Please select at least one article to approve.")
//            return
//        }
//        
//        var updatedArticlesCount = 0
//        
//        for authorArticles in groupedArticles.values {
//            for article in authorArticles where selectedArticles.contains(article.id ?? "") {
//                let approvedByList: [String]
//                if let jsonString = article.approvedBy,
//                   let data = jsonString.data(using: .utf8),
//                   let decoded = try? JSONDecoder().decode([String].self, from: data) {
//                    approvedByList = decoded
//                } else {
//                    approvedByList = []
//                }
//                
//                if !approvedByList.contains(currentUser.username) {
//                    var updatedList = approvedByList
//                    updatedList.append(currentUser.username)
//                    
//                    if let jsonData = try? JSONEncoder().encode(updatedList),
//                       let jsonString = String(data: jsonData, encoding: .utf8) {
//                        article.approvedBy = jsonString
//                        article.approveCount = Int32(updatedList.count) // 👈 Update approveCount
//                        updatedArticlesCount += 1
//                    }
//
//                }
//            }
//        }
//        
//        do {
//            try context.save()
//            fetchArticles()
//            showAlertWith(message: "\(updatedArticlesCount) article(s) approved successfully.")
//            print("✅ Approved successfully")
//        } catch {
//            print("❌ Save failed: \(error.localizedDescription)")
//        }
//    }
    
//    func markApprove() {
//        guard let currentUser = sessionManager.getUser() else {
//            print("❌ No user logged in")
//            return
//        }
//        
//        guard !selectedArticles.isEmpty else {
//            showAlertWith(message: "Please select at least one article to approve.")
//            return
//        }
//        
//        context.perform {
//            var updatedArticlesCount = 0
//            
//            for authorArticles in self.groupedArticles.values {
//                for article in authorArticles where self.selectedArticles.contains(article.id ?? "") {
//                    guard let objectID = article.objectID as? NSManagedObjectID,
//                          let freshArticle = try? self.context.existingObject(with: objectID) as? ArticleMetadata else {
//                        continue
//                    }
//                    
//                    let approvedByList: [String]
//                    if let jsonString = freshArticle.approvedBy,
//                       let data = jsonString.data(using: .utf8),
//                       let decoded = try? JSONDecoder().decode([String].self, from: data) {
//                        approvedByList = decoded
//                    } else {
//                        approvedByList = []
//                    }
//                    
//                    if !approvedByList.contains(currentUser.username) {
//                        var updatedList = approvedByList
//                        updatedList.append(currentUser.username)
//                        
//                        if let jsonData = try? JSONEncoder().encode(updatedList),
//                           let jsonString = String(data: jsonData, encoding: .utf8) {
//                            freshArticle.approvedBy = jsonString
//                            freshArticle.approveCount = Int32(updatedList.count)
//                            updatedArticlesCount += 1
//                        }
//                    }
//                }
//            }
//            
//            do {
//                try self.context.save()
//                DispatchQueue.main.async {
//                    self.fetchArticles()
//                    self.showAlertWith(message: "\(updatedArticlesCount) article(s) approved successfully.")
//                    print("✅ Approved successfully")
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.showAlertWith(message: "Failed to save approvals. Try again.")
//                    print("❌ Save failed: \(error.localizedDescription)")
//                }
//            }
//        }
//    }

    func markApprove() {
        guard let currentUser = sessionManager.getUser() else {
            print("❌ No user logged in")
            return
        }
        
        guard !selectedArticles.isEmpty else {
            showAlertWith(message: "⚠️ Please select at least one article to approve.")
            return
        }
        
        var updatedArticlesCount = 0
        
        for authorArticles in groupedArticles.values {
            for article in authorArticles where selectedArticles.contains(article.id ?? "") {
                let approvedByList: [String]
                if let jsonString = article.approvedBy,
                   let data = jsonString.data(using: .utf8),
                   let decoded = try? JSONDecoder().decode([String].self, from: data) {
                    approvedByList = decoded
                } else {
                    approvedByList = []
                }
                
                if !approvedByList.contains(currentUser.username) {
                    var updatedList = approvedByList
                    updatedList.append(currentUser.username)
                    
                    if let jsonData = try? JSONEncoder().encode(updatedList),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        article.approvedBy = jsonString
                        article.approveCount = Int32(updatedList.count)
                        updatedArticlesCount += 1
                    }
                }
            }
        }
        
        do {
            try context.save()
            fetchArticles()
            
            if updatedArticlesCount > 0 {
                showAlertWith(message: "✅ \(updatedArticlesCount) article(s) approved successfully.")
            } else {
                showAlertWith(message: "ℹ️ No new approvals were made. All selected articles are already approved.")
            }
            print("✅ Approved successfully")
        } catch {
            print("❌ Save failed: \(error.localizedDescription)")
            showAlertWith(message: "❌ Failed to save approvals. Please try again.")
        }
    }

    
}
