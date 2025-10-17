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
    
}

struct HomeService: HomeServiceProtocol {
    
    
    func getHabits(completion: @escaping CompletionHandler<Habit>) {
        return NetworkService.fetchData(request: HomeRouter.getHabits, completion: completion)
    }
    
    func getReport(day: String, completion: @escaping CompletionHandler<Report>) {
        return NetworkService.fetchData(request: HomeRouter.getReport(days: day), completion: completion)
    }
    
}
