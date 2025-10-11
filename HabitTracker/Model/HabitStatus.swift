//
//  HabitStatus.swift
//  HabitTracker
//
//  Created by Shameem on 11/10/25.
//

import Foundation

// MARK: - HabitStatus for Today's View
struct HabitStatus: Identifiable {
    let id = UUID()
    let habit: HabitElement
    var isCompleted: Bool = false
    
    init(habit: HabitElement, isCompleted: Bool = false) {
        self.habit = habit
        self.isCompleted = isCompleted
    }
}