//
//  AuthService.swift
//  HabitTracker
//
//  Created by Shameem on 15/10/25.
//

import Foundation

// MARK: - Auth Service Protocol
protocol AuthServiceProtocol {
    func login(data: LoginRequest,  completion: @escaping CompletionHandler<AuthResponse>)
    func signup(data: SignupRequest,  completion: @escaping CompletionHandler<AuthResponse>)
    func getProfile( completion: @escaping CompletionHandler<User>)
    func logout() async throws -> Bool
    func validateToken() async throws -> Bool
}

// MARK: - Auth Service Implementation
struct AuthService: AuthServiceProtocol {
    
    func login(data: LoginRequest,  completion: @escaping CompletionHandler<AuthResponse>){
        return NetworkService.fetchData(request: AuthRouter.login(request: data), completion: completion)
    }
    
    func signup(data: SignupRequest,  completion: @escaping CompletionHandler<AuthResponse>){
        return NetworkService.fetchData(request: AuthRouter.signup(request: data), completion: completion)
    }
    
    func getProfile( completion: @escaping CompletionHandler<User>) {
        return NetworkService.fetchData(request: HomeRouter.profile, completion: completion)
    }
    
    func logout() async throws -> Bool {
       
        return true
    }
    
    func validateToken() async throws -> Bool {
        let token = UserDefaults.standard.string(forKey: "auth_token")
        return token != nil
    }
}


