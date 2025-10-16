//
//  AuthRequest.swift
//  HabitTracker
//
//  Created by Shameem on 16/10/25.
//

import Foundation

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

