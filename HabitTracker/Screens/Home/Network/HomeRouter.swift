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
    case profile
}


extension HomeRouter: BaseRouter {
    var baseURL: String {
       return Path.baseUrl
    }
    
    var path: String {
        switch self {
        case .getHabits:
            return Path.getHabits
        case .getReport(_):
            return Path.getReport
        case .profile:
            return Path.profile
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHabits:
            return .get
        case .getReport:
            return .get
        case .profile:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return [
            "Authorization": "Bearer \(AuthStorage.shared.getAuthToken() ?? "")"
         ]
    }
    
    var body: [String : Any]? {
        return nil
    }
    
    var parameters: [String : String]? {
        switch self {
       
        case .getReport(let days):
            return  [
                "days": days,
            ]
       
        default:
            return nil
        }
    }
    
 
}
