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
    let report: [ReportElement]?
}

// MARK: - ReportElement
struct ReportElement: Codable {
    let date: String?
    let done: Int?
    let undone: Int?
    let habits: [HabitsReport]?
}

struct HabitsReport: Codable {
    let name: String?
    let completed: Bool?
}
