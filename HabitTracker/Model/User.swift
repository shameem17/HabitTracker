//
//  User.swift
//  HabitTracker
//
//  Created by Shameem on 15/10/25.
//

import Foundation

// MARK: - User Model
struct User: Codable {
    let success: Bool?
    let profile: Profile?
    let habits: [HabitElement]?
}
// MARK: - Profile
struct Profile: Codable {
    let name, email: String?
    let createdAt: CreatedAt?
}

// MARK: - CreatedAt
struct CreatedAt: Codable {
    let seconds, nanoseconds: Int?

    enum CodingKeys: String, CodingKey {
        case seconds = "_seconds"
        case nanoseconds = "_nanoseconds"
    }
}


// MARK: - Validation Error Model
struct ValidationError {
    let field: String
    let message: String
}
