//
//  NewsApiResponse.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//


struct NewsApiResponse: Codable {
    let articles: [NewsArticle]
}

struct NewsArticle: Codable {
    let title: String?
    let description: String?
    let content: String?
    let author: String?
    let approvedBy: [String]? 
}
