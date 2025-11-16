//
//  Report.swift
//  HabitTracker
//
//  Created by Shameem on 22/9/25.
//

import Foundation

// MARK: - Report
struct Report: Codable {
    let success: Bool?
    let totalHabitCount: Int?
    var report: [ReportElement]?
}

// MARK: - ReportElement
struct ReportElement: Codable {
    let date: String?
    let done: Int?
    let undone: Int?
    var habits: [HabitsReport]?
}

struct HabitsReport: Codable {
    let name: String?
    var completed: Bool?
}
