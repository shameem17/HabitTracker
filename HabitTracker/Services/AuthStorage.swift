//
//  AuthStorage.swift
//  HabitTracker
//
//  Created by Shameem on 15/10/25.
//

import Foundation

// MARK: - Auth Storage Helper
class AuthStorage {
    static let shared = AuthStorage()
    
    private init() {}
    
    func saveAuthData(user: User, token: String) {
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: "user_data")
        }
        UserDefaults.standard.set(token, forKey: "auth_token")
    }
    
    func getCurrentUser() -> User? {
        guard let userData = UserDefaults.standard.data(forKey: "user_data"),
              let user = try? JSONDecoder().decode(User.self, from: userData) else {
            return nil
        }
        return user
    }
    
    func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "auth_token")
    }
    
    func clearAuthData() {
        UserDefaults.standard.removeObject(forKey: "auth_token")
        UserDefaults.standard.removeObject(forKey: "user_data")
    }
    
    var isAuthenticated: Bool {
        return getAuthToken() != nil
    }
}
