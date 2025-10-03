//
//  DateHelper.swift
//  HabitTracker
//
//  Created by Shameem on 29/9/25.
//

import Foundation
protocol DateHelperProtocol {
    func getTodayDate() -> String
    func isDateToday(date: String) -> Bool
    func getDayName(date: String) ->String
}

final class DateHelper: DateHelperProtocol {
    
    private lazy var formater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    func getTodayDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: Date()).uppercased()
    }
    
    func getDayName(date: String) ->String{
        let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone(secondsFromGMT: 0) // important if API is UTC
            
            if let date = formatter.date(from: date) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "EEE"  // Full day name (Monday, Tuesday, …)
                return outputFormatter.string(from: date)
            }
            return ""
    }
    
    func isDateToday(date: String) -> Bool{
        if let apiDate = formater.date(from: date) {
            let calendar = Calendar.current
            if calendar.isDateInToday(apiDate) {
                return true
            } else {
                return false
            }
        }
        return false
    }
        
}

