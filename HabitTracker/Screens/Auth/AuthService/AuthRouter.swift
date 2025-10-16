//
//  AuthRouter.swift
//  HabitTracker
//
//  Created by Shameem on 16/10/25.
//

import Foundation

enum AuthRouter{
    case login(request: LoginRequest)
    case signup(request: SignupRequest)
}

extension AuthRouter: BaseRouter{
    var baseURL: String {
        return Path.baseUrl
    }
    
    var path: String {
        switch self {
        case .login:
            return Path.login
        case .signup:
            return Path.signUp
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var headers: [String : String]? {
       return nil
    }
    
    var body: [String : Any]? {
        switch self {
        case .login(let request):
            return [
                "email": request.email,
                "password": request.password
            ]
        case .signup(let request):
            return [
                "name": request.name,
                "email": request.email,
                "password": request.password
            ]
       
        }
    }
    
    var parameters: [String : String]? {
        return nil
    }
    
    
}
