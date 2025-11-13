//
//  TodayViewModel.swift
//  HabitTracker
//
//  Created by Shameem on 18/10/25.
//

import Foundation

protocol AddNewHabitProtocol{
    func addNewHabit(name: String, icon: String)
}

final class UpdateViewModel: ObservableObject{
    @Published var apiLoding: Bool = false
    @Published var errorMessage: String?
    @Published private var updatingList: [HabitElement] = []
    @Published var habits: [HabitElement]
    @Published var showAllHabits: Bool
    @Published var isLoading: Bool = false
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
    
    public static func getTodayViewModel(report: Report?, habits: [HabitElement]) -> UpdateViewModel{
        let viewModel = UpdateViewModel()
        viewModel.report = report
        viewModel.habits = habits
        return viewModel
    }
         
}

extension UpdateViewModel{
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

extension UpdateViewModel{
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
        isLoading = true
        let list = makeUpdatedList()
        apiService.updateHabitStatus(data: list) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(_):
                print("Habit updated successfully")
                self?.clearUpdatedList()
            case .failure(let error):
                if error == .authRequired {
                    self?.logout()
                }
                print("Failed to update habit: \(error.localizedDescription)")
            }
        }
            
    }
}

extension UpdateViewModel: AddNewHabitProtocol{
    func addNewHabit(name: String, icon: String) {
        print("new habit added \(name)")
        self.habits.insert(HabitElement(name: name, icon: icon, completed: false), at: 0)
    }
}
