//
//  UpdateHabit.swift
//  HabitTracker
//
//  Created by Shameem on 22/9/25.
//

import Foundation

// MARK: - Habit
struct UpdateHabit: Codable {
    let success: Bool?
    let habit: HabitClass?
}

// MARK: - HabitClass
struct HabitClass: Codable {
    let name, icon: String?
}
