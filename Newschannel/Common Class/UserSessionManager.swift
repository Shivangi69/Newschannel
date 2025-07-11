//
//  UserRole.swift
//  Newschannel
//
//  Created by apple on 10/07/25.
//


import Foundation

import Foundation

enum UserRole: String, Codable {
    case author
    case reviewer
}

class UserSessionManager: ObservableObject {
     let userKey = "currentUser"
    
    struct User: Codable {
        let username: String
        let role: UserRole
    }

    
    enum UserRole: String, Codable {
        case author
        case reviewer
    }
    
    func saveUser(username: String, role: UserRole) {
        let user = User(username: username, role: role)
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    func getUser() -> User? {
        if let savedUserData = UserDefaults.standard.data(forKey: userKey),
           let savedUser = try? JSONDecoder().decode(User.self, from: savedUserData) {
            return savedUser
        }
        return nil
    }
    
    func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}
