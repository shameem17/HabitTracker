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
            UserDefaults.standard.set(userData, forKey: AppPrefix.userKey)
        }
    }
    func saveAuthData(response: AuthResponse) {
       
        UserDefaults.standard.set(response.idToken, forKey: AppPrefix.accessTokenKey)
        UserDefaults.standard.set(response.refreshToken, forKey: AppPrefix.refreshTokenKey)
    }
    
    func getCurrentUser() -> User? {
        guard let userData = UserDefaults.standard.data(forKey: AppPrefix.userKey),
              let user = try? JSONDecoder().decode(User.self, from: userData) else {
            return nil
        }
        return user
    }
    
    func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: AppPrefix.accessTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: AppPrefix.refreshTokenKey)
    }
    
    func clearAuthData() {
        UserDefaults.standard.removeObject(forKey: AppPrefix.accessTokenKey)
        UserDefaults.standard.removeObject(forKey: AppPrefix.userKey)
        UserDefaults.standard.removeObject(forKey: AppPrefix.refreshTokenKey)
    }
    
    var isAuthenticated: Bool {
        return getAuthToken() != nil
    }
}
