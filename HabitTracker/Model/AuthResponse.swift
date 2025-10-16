//
//  AuthResponse.swift
//  HabitTracker
//
//  Created by Shameem on 16/10/25.
//

import Foundation

// MARK: - Authentication Response Models
struct AuthResponse: Codable {
    let idToken, refreshToken, userID, expiresIn: String?

        enum CodingKeys: String, CodingKey {
            case idToken, refreshToken
            case userID = "userId"
            case expiresIn
        }
}
