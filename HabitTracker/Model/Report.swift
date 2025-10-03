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
    let date, day, bedTime, wakeupTime: String?
    let fajar, asr, dhuhr, badHabit: String?
    let done, undone: Int?

    enum CodingKeys: String, CodingKey {
        case date, day
        case bedTime = "Bed Time"
        case wakeupTime = "Wakeup Time"
        case fajar = "Fajar"
        case asr = "Asr"
        case dhuhr = "Dhuhr"
        case badHabit = "Bad Habit"
        case done, undone
    }
}
