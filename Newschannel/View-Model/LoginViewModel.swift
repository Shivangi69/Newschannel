import SwiftUI
import CoreData
import Network

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    let sessionManager = UserSessionManager()
    private let apiService = MockAPIService()
    private let localDB = LocalDatabaseManager()
    
    private var autoSyncTimer: Timer?
    private let networkMonitor = NetworkMonitor.shared

    func login(with role: UserRole, username: String) {
        let trimmedName = username.trimmingCharacters(in: .whitespaces)
        
        // Validate name is not empty
        guard !trimmedName.isEmpty else {
            showAlertWith(message: "Name cannot be empty.")
            return
        }
        
        // Validate name length
        guard trimmedName.count >= 3 else {
            showAlertWith(message: "Name must be at least 3 characters long.")
            return
        }
        
        // Special rule: Author must be 'Robert'
        if role == .author && trimmedName.lowercased() != "robert" {
            showAlertWith(message: "Author login is allowed only for user 'Robert'.")
            return
        }
        
        // Save user session
        sessionManager.saveUser(username: trimmedName, role: UserSessionManager.UserRole(rawValue: role.rawValue)!)

        // Auto-sync on login
        syncDataIfNeeded()
        
        // Start background auto-sync every 15 minutes
        startAutoSync()
        
        // Check Core Data for articles
        if localDB.hasArticles() {
            isLoggedIn = true
        } else {
            showAlertWith(message: "No articles found locally. Please sync the app first.")
        }
    }

    func syncData() {
        apiService.fetchArticlesFromAPI { [weak self] articles in
            DispatchQueue.main.async {
                if articles.isEmpty {
                    self?.showAlertWith(message: "Failed to sync articles. Please try again.")
                } else {
                    self?.localDB.saveArticles(articles)
                    self?.showAlertWith(message: "Articles synced successfully.")
                }
            }
        }
    }
    
    private func syncDataIfNeeded() {
        if networkMonitor.isConnected {
            print("Internet available: Syncing articles...")
            syncData()
        } else {
            print("No internet. Will auto-sync when connection restores.")
        }
    }

    func startAutoSync() {
        autoSyncTimer?.invalidate() // Reset existing timer if any
        autoSyncTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.syncDataIfNeeded()
        }
    }

    func stopAutoSync() {
        autoSyncTimer?.invalidate()
        autoSyncTimer = nil
    }

    /// Shows alert with a custom message
    func showAlertWith(message: String) {
        alertMessage = message
        showAlert = true
    }
}
