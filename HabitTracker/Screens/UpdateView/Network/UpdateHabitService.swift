//
//  UpdateHabitProtocol.swift
//  HabitTracker
//
//  Created by Shameem on 18/10/25.
//

protocol UpdateHabitProtocol {
    func updateHabitStatus(data: UpdateHabit, completion: @escaping CompletionHandler<SuccessResponse>)
}

struct UpdateHabitService: UpdateHabitProtocol {
    func updateHabitStatus(data: UpdateHabit, completion: @escaping CompletionHandler<SuccessResponse>) {
        NetworkService.fetchData(request: UpdateHabitRouter.updateHabitStatus(data: data), completion: completion)
    }
}
