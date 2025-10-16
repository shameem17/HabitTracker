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
    
    func saveUser(user: User) {
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: "user_data")
        }
    }
    func saveAuthData(response: AuthResponse) {
       
        UserDefaults.standard.set(response.idToken, forKey: "auth_token")
        UserDefaults.standard.set(response.refreshToken, forKey: "refreshToken")
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
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: "refreshToken")
    }
    
    func clearAuthData() {
        UserDefaults.standard.removeObject(forKey: "auth_token")
        UserDefaults.standard.removeObject(forKey: "user_data")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
    }
    
    var isAuthenticated: Bool {
        return getAuthToken() != nil
    }
}
