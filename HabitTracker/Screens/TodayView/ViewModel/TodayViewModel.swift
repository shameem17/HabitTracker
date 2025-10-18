//
//  TodayViewModel.swift
//  HabitTracker
//
//  Created by Shameem on 18/10/25.
//

import Foundation

final class TodayViewModel: ObservableObject{
    @Published var apiLoding: Bool = false
    @Published var errorMessage: String?
    @Published private var updatingList: [HabitElement] = []
    @Published var habits: [HabitElement]
    @Published var showAllHabits: Bool
    private var apiService: UpdateHabitProtocol = UpdateHabitService()
    private var report: Report?

    private var dateHelper: DateHelperProtocol
    var hasLatestUpdates: Bool{
        return !updatingList.isEmpty
    }
    
    init(dateHelper: DateHelperProtocol = DateHelper()){
        self.dateHelper = dateHelper
        self.showAllHabits = false
        habits = []
    }
    
    public static func getTodayViewModel(report: Report?, habits: [HabitElement]) -> TodayViewModel{
        let viewModel = TodayViewModel()
        viewModel.report = report
        viewModel.habits = habits
        return viewModel
    }
         
}

extension TodayViewModel{
    private func resetLoading(loading: Bool){
        DispatchQueue.main.async{[weak self] in
            self?.apiLoding = loading
        }
    }
    func formattedToday()->String{
        return dateHelper.getTodayDate()
    }
    
    func addUpdatedHabit(habitName: String, completed: Bool){
        if updatingList.contains(where: { $0.name == habitName }) {
            updatingList.removeAll(where: { $0.name == habitName })
            return
        }
        self.updatingList.append(HabitElement(name: habitName, icon: nil, completed: completed))
    }
    
    func clearUpdatedList(){
        self.updatingList.removeAll()
    }
    
    func prepareTodayHabit(){
        self.resetLoading(loading: true)
        let today = self.report?.report?.filter({ dateHelper.isDateToday(date: $0.date) }).first
        habits = habits.map { habit in
            var updatedHabit = habit
            if let todayHabits = today?.habits,
               let matched = todayHabits.first(where: { $0.name == habit.name }) {
                updatedHabit.completed = matched.completed
            } else {
                updatedHabit.completed = false
            }
            return updatedHabit
        }
        self.resetLoading(loading: false)
        self.showAllHabits = true
    }
    func isHabitsEmpty() -> Bool {
        return habits.isEmpty
    }
    
    func getHabitsCount() -> Int {
        return habits.count
    }
    
}

extension TodayViewModel{
    func logout(){
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    private func makeUpdatedList() -> UpdateHabit{
        let habits = updatingList.map({ habit in
            HabitClass(name: habit.name ?? "", complete: habit.isCompleted)
        })
        let updateHabitsList = UpdateHabit(date: dateHelper.getDateToday(), habits: habits)
        return updateHabitsList
    }
    
    func updateHabit(){
        let list = makeUpdatedList()
        apiService.updateHabitStatus(data: list) { [weak self] result in
            switch result {
            case .success(_):
                print("Habit updated successfully")
            case .failure(let error):
                print("Failed to update habit: \(error.localizedDescription)")
            }
        }
            
    }
}
