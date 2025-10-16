//
//  HomeService.swift
//  HabitTracker
//
//  Created by Shameem on 22/9/25.
//

import Foundation

protocol HomeServiceProtocol {
    func getReport(day: String, completion: @escaping CompletionHandler<Report>)
    func getHabits(completion: @escaping CompletionHandler<Habit>)
    func getProfile( completion: @escaping CompletionHandler<User>)
    
}

struct HomeService: HomeServiceProtocol {
    func getProfile( completion: @escaping CompletionHandler<User>) {
        return NetworkService.fetchData(request: HomeRouter.profile, completion: completion)
    }
    
    func getHabits(completion: @escaping CompletionHandler<Habit>) {
        return NetworkService.fetchData(request: HomeRouter.getHabits, completion: completion)
    }
    
    func getReport(day: String, completion: @escaping CompletionHandler<Report>) {
        return NetworkService.fetchData(request: HomeRouter.getReport(days: day), completion: completion)
    }
    
}
