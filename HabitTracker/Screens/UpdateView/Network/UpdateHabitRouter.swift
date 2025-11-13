//
//  UpdateHabitRouter.swift
//  HabitTracker
//
//  Created by Shameem on 18/10/25.
//

enum UpdateHabitRouter{
    case updateHabitStatus(data: UpdateHabit)
}

extension UpdateHabitRouter: BaseRouter{
    var baseURL: String {
        return Path.baseUrl
    }
    
    var path: String {
        return Path.updateHabit
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
        case .updateHabitStatus(let data):
            return  [
                "date": data.date,
                "habits": data.habits.map { [
                    "name": $0.name,
                    "completed": $0.complete
                ]}
            ]
        }
        
    }
    
    var parameters: [String : String]? {
        return nil
    }
    
    
}
