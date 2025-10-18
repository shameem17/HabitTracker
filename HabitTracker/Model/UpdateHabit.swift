//
//  UpdateHabit.swift
//  HabitTracker
//
//  Created by Shameem on 22/9/25.
//

import Foundation

// MARK: - Habit
struct UpdateHabit: Codable {
    var date: String
    var habits: [HabitClass]
}

// MARK: - HabitClass
struct HabitClass: Codable {
    let name: String
    let complete: Bool
}
