//
//  LocalDatabaseManager.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//


import CoreData

class LocalDatabaseManager {
    private let viewContext = PersistenceController.shared.container.viewContext
    
    /// Check if there are any saved articles
    func hasArticles() -> Bool {
        let request: NSFetchRequest<ArticleMetadata> = ArticleMetadata.fetchRequest()
        request.fetchLimit = 1
        do {
            let count = try viewContext.count(for: request)
            return count > 0
        } catch {
            print("Failed to check articles: \(error.localizedDescription)")
            return false
        }
    }
    

    func saveArticles(_ articles: [NewsArticle]) {
        let viewContext = PersistenceController.shared.container.viewContext
        
        // Optional: Clear old data before saving
        clearAllArticles()
        
        for article in articles {
            let metadata = ArticleMetadata(context: viewContext)
            metadata.id = UUID().uuidString
            metadata.title = article.title ?? "No Title"
            metadata.descriptionText = article.description ?? "No Description"
            metadata.author = article.author ?? "Unknown"
            
            // Handle approvedBy from API if available
            let approvedByArray = article.approvedBy ?? []
            let approvedByJSONString: String
            if let jsonData = try? JSONEncoder().encode(approvedByArray),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                approvedByJSONString = jsonString
            } else {
                approvedByJSONString = "[]"
            }
            
            metadata.approvedBy = approvedByJSONString
            metadata.approveCount = Int32(approvedByArray.count)
            
            // Save related details
            let detail = ArticleDetail(context: viewContext)
            detail.id = metadata.id
            detail.fullContent = article.content ?? "No Content Available"
            metadata.detail = detail // Link relationship
        }
        
        do {
            try viewContext.save()
            print("✅ Articles saved to Core Data")
        } catch {
            print("❌ Failed to save articles: \(error.localizedDescription)")
        }
    }

    func clearAllArticles() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = ArticleMetadata.fetchRequest()
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = ArticleDetail.fetchRequest()
        
        let batchDelete1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        let batchDelete2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        
        let viewContext = PersistenceController.shared.container.viewContext
        do {
            try viewContext.execute(batchDelete1)
            try viewContext.execute(batchDelete2)
            print("🧹 Cleared old articles from Core Data")
        } catch {
            print("❌ Failed to clear old articles: \(error.localizedDescription)")
        }
    }

}
