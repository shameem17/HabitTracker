//
//  TokenResponse.swift
//  HabitTracker
//
//  Created by Shameem on 16/10/25.
//

import Foundation

// MARK: - Token Response Model
struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let tokenType: String?
    let expiresIn: Int?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

// MARK: - Refresh Token Request Model
struct RefreshTokenRequest: Codable {
    let refreshToken: String
    let grantType: String = "refresh_token"
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case grantType = "grant_type"
    }
}