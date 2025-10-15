//
//  AuthService.swift
//  HabitTracker
//
//  Created by Shameem on 15/10/25.
//

import Foundation

// MARK: - Auth Service Protocol
protocol AuthServiceProtocol {
    func login(request: LoginRequest) async throws -> AuthResponse
    func signup(request: SignupRequest) async throws -> AuthResponse
    func logout() async throws -> Bool
    func validateToken() async throws -> Bool
}

// MARK: - Auth Service Implementation
class AuthService: AuthServiceProtocol {
    
    init() {
        // NetworkService uses static methods, no instance needed
    }
    
    func login(request: LoginRequest) async throws -> AuthResponse {
        // TODO: Replace with actual API endpoint
        let endpoint = "/auth/login"
        
        // For now, simulate API call with delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        // Mock successful response
        if request.email.contains("@") && request.password.count >= 6 {
            return AuthResponse(
                success: true,
                message: "Login successful",
                user: User(
                    id: UUID().uuidString,
                    email: request.email,
                    name: "User",
                    createdAt: nil,
                    updatedAt: nil
                ),
                token: "mock_jwt_token_\(UUID().uuidString)"
            )
        } else {
            return AuthResponse(
                success: false,
                message: "Invalid email or password",
                user: nil,
                token: nil
            )
        }
    }
    
    func signup(request: SignupRequest) async throws -> AuthResponse {
        // TODO: Replace with actual API endpoint
        let endpoint = "/auth/signup"
        
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock successful response
        if request.email.contains("@") && request.password.count >= 6 && request.password == request.confirmPassword {
            return AuthResponse(
                success: true,
                message: "Account created successfully",
                user: User(
                    id: UUID().uuidString,
                    email: request.email,
                    name: request.name,
                    createdAt: nil,
                    updatedAt: nil
                ),
                token: "mock_jwt_token_\(UUID().uuidString)"
            )
        } else {
            return AuthResponse(
                success: false,
                message: "Invalid signup data",
                user: nil,
                token: nil
            )
        }
    }
    
    func logout() async throws -> Bool {
        // Clear stored token
        UserDefaults.standard.removeObject(forKey: "auth_token")
        UserDefaults.standard.removeObject(forKey: "user_data")
        return true
    }
    
    func validateToken() async throws -> Bool {
        // Check if token exists and is valid
        let token = UserDefaults.standard.string(forKey: "auth_token")
        return token != nil
    }
}


