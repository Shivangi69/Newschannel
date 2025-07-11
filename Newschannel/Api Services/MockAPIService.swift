//
//  MockArticle.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//


import Foundation

struct MockArticle {
    let id: String
    let title: String
    let description: String
    let author: String
    let fullContent: String
}

//class MockAPIService {
//    private let allMockArticles: [MockArticle] = [
//        MockArticle(id: UUID().uuidString, title: "AI Advances in 2025", description: "How AI is changing work and life.", author: "Robert", fullContent: "Full article about AI in 2025."),
//        MockArticle(id: UUID().uuidString, title: "India Hosts G20 Summit", description: "Key takeaways from the global meet.", author: "Priya", fullContent: "Detailed summary of G20 decisions."),
//        MockArticle(id: UUID().uuidString, title: "Mars Mission Launched", description: "NASA's 2025 mission takes off.", author: "Robert", fullContent: "Deep dive into the Mars mission."),
//        MockArticle(id: UUID().uuidString, title: "Electric Cars Dominate Sales", description: "EVs surpass gas cars in US.", author: "Alice", fullContent: "What's driving EV adoption."),
//        MockArticle(id: UUID().uuidString, title: "Global Markets See Recovery", description: "Stock markets bounce back in Q2.", author: "Priya", fullContent: "Finance leaders share insights."),
//        MockArticle(id: UUID().uuidString, title: "New Education Policy Rolled Out", description: "Govt announces major changes.", author: "Sanjay", fullContent: "Breakdown of the new structure."),
//        MockArticle(id: UUID().uuidString, title: "Climate Talks Resume", description: "Leaders meet to reduce emissions.", author: "Alice", fullContent: "Agenda and early outcomes."),
//        MockArticle(id: UUID().uuidString, title: "AI Regulation Act Passed", description: "New rules for AI safety in tech.", author: "Robert", fullContent: "What the act covers and why."),
//        MockArticle(id: UUID().uuidString, title: "Olympics 2025: Countdown Begins", description: "Host city prepares for big event.", author: "Priya", fullContent: "Infrastructure updates and plans."),
//        MockArticle(id: UUID().uuidString, title: "Healthcare Tech Revolution", description: "How wearables are saving lives.", author: "Sanjay", fullContent: "Future of remote diagnosis.")
//    ]
//    
//    /// Simulates fetching paginated articles
//    func fetchArticles(offset: Int = 0, limit: Int = 5, completion: @escaping ([MockArticle]) -> Void) {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
//            let end = min(offset + limit, self.allMockArticles.count)
//            let paginated = Array(self.allMockArticles[offset..<end])
//            completion(paginated)
//        }
//    }
//}

class MockAPIService {
    private let apiKey = "d053138655c143a7935071338c79f400"
    private let urlString = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey="
    
    func fetchArticlesFromAPI(completion: @escaping ([NewsArticle]) -> Void) {
        guard let url = URL(string: "\(urlString)\(apiKey)") else {
            print("❌ Invalid URL")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ API Error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("❌ No data from API")
                completion([])
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(NewsApiResponse.self, from: data)
                completion(decodedResponse.articles)
            } catch {
                print("❌ JSON decode error: \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }
}


