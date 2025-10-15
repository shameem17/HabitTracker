//
//  User.swift
//  HabitTracker
//
//  Created by Shameem on 15/10/25.
//

import Foundation

// MARK: - User Model
struct User: Codable {
    let id: String
    let email: String
    let name: String
    let createdAt: String?
    let updatedAt: String?
}

// MARK: - Authentication Request Models
struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct SignupRequest: Codable {
    let name: String
    let email: String
    let password: String
    let confirmPassword: String
}

// MARK: - Authentication Response Models
struct AuthResponse: Codable {
    let success: Bool
    let message: String
    let user: User?
    let token: String?
}

// MARK: - Validation Error Model
struct ValidationError {
    let field: String
    let message: String
}