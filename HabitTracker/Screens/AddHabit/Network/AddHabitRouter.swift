//
//  AddHabitRouter.swift
//  HabitTracker
//
//  Created by Shameem on 18/10/25.
//

import Foundation

enum AddHabitRouter{
    case addHabit(name: String, icon: String)
}

extension AddHabitRouter: BaseRouter{
    var baseURL: String {
        return Path.baseUrl
    }
    
    var path: String {
        return Path.addHabit
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var headers: [String : String]? {
        return [
            "Authorization": "Bearer \(AuthStorage.shared.getAuthToken() ?? "")"
         ]
    }
    
    var body: [String : Any]? {
        switch self {
        case .addHabit(let name, let icon):
            return [
                "habit": [
                    "name": name,
                    "icon": icon
                ]
            ]
        }
    }
    var parameters: [String : String]? {
        return nil
    }
}





