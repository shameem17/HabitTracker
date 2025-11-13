//
//  CreateHabitRequest.swift
//  HabitTracker
//
//  Created by Shameem on 18/10/25.
//

import Foundation

// MARK: - Create Habit Request Model
struct CreateHabitRequest: Codable {
    let name: String
    let icon: String?
    let description: String?
    let category: String?
    let frequency: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case icon
        case description
        case category
        case frequency
    }
}

// MARK: - Create Habit Response Model
struct CreateHabitResponse: Codable {
    let id: String
    let name: String
    let icon: String?
    let description: String?
    let category: String?
    let frequency: String
    let createdAt: String
    let updatedAt: String
    let isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
        case description
        case category
        case frequency
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isActive = "is_active"
    }
}