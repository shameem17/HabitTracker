//
//  AddHabitService.swift
//  HabitTracker
//
//  Created by Shameem on 18/10/25.
//

import Foundation

protocol AddHabitProtocol {
    func addHabit(name: String, icon: String, completion: @escaping (CompletionHandler<SuccessResponse>))
}

struct AddHabitService: AddHabitProtocol {
    func addHabit(name: String, icon: String, completion: @escaping (CompletionHandler<SuccessResponse>)) {
        return NetworkService.fetchData(request: AddHabitRouter.addHabit(name: name, icon: icon), completion: completion)
    }
    
}
