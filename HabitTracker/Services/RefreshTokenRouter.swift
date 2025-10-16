//
//  RefreshTokenRouter.swift
//  HabitTracker
//
//  Created by Shameem on 16/10/25.
//

import Foundation

enum RefreshTokenRouter{
    case refreshToken(refreshToken: String)
}

extension RefreshTokenRouter: BaseRouter {
    var baseURL: String {
        return Path.baseUrl
    }
    
    var path: String {
        switch self {
        case .refreshToken:
            return "refreshToken"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .refreshToken:
            return .post
        }
    }
    
    var parameters: [String: String]? {
        return nil
    }
    
    var body: [String: Any]? {
        switch self {
        case .refreshToken(let refreshToken):
            return [
                "refreshToken": refreshToken,
            ]
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
}
