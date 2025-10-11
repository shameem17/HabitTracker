//
//  Habit.swift
//  HabitTracker
//
//  Created by Shameem on 22/9/25.
//

import Foundation

// MARK: - Habit
struct Habit: Codable {
    let success: Bool?
    let habits: [HabitElement]?
}

// MARK: - HabitElement
struct HabitElement: Codable {
    let id = UUID()
    let name, icon: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case icon = "icon"
    }
}
