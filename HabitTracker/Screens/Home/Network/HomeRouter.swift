//
//  HomeRouter.swift
//  HabitTracker
//
//  Created by Shameem on 22/9/25.
//
import Foundation

enum HomeRouter{
    case getHabits
    case getReport(days: String)
    case updateHabit(date: String, habits: [String: String])
    case addHabit(name: String, icon: String)
}


extension HomeRouter: BaseRouter {
    var baseURL: String {
       return Path.baseUrl
    }
    
    var path: String {
        return "/\(Path.apiKey)/exec"
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHabits:
            return .get
        case .getReport(let days):
            return .get
        case .updateHabit(let date, let habits):
            return .post
        case .addHabit(let name, let icon):
            return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getHabits:
            return nil
        case .getReport(let days):
            return nil
        case .updateHabit(let date, let habits):
            return nil
        case .addHabit(let name, let icon):
            return nil
        }
    }
    
    var body: [String : Any]? {
        return nil
    }
    
    var parameters: [String : String]? {
        switch self {
        case .getHabits:
            return [
                "action": "getHabits",
                "key": Path.apiSecret
            ]
        case .getReport(let days):
            return  [
                "action": "getReport",
                "days": days,
                "key": Path.apiSecret
            ]
        case .updateHabit(let date, let habits):
            return [
                "auth": Path.apiSecret,
                "action": "updateHabit",
                "date": date,
                "habits": habits.debugDescription
            ]
        case .addHabit(let name, let icon):
            return [
                "auth": Path.apiSecret,
                "action": "addHabit",
                "habit": ["name": name, "icon": icon].debugDescription
            ]
        }
    }
    
 
}
