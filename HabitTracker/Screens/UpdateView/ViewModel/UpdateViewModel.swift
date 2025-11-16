//
//  TodayViewModel.swift
//  HabitTracker
//
//  Created by Shameem on 18/10/25.
//

import Foundation
import Combine

final class UpdateViewModel: ObservableObject{
    // Use centralized data manager
    private let dataManager = HabitDataManager.shared
    @Published private var updatingList: [HabitElement] = []
    @Published var showAllHabits: Bool = false
    @Published var isLoading: Bool = false
    @Published var refreshId = UUID()
    private var apiService: UpdateHabitProtocol = UpdateHabitService()
    private var cancellables = Set<AnyCancellable>()
    private var dateHelper: DateHelperProtocol
    
    // Computed properties that reference centralized data
    var apiLoding: Bool { dataManager.isLoading }
    var errorMessage: String? { dataManager.errorMessage }
    var habits: [HabitElement] { dataManager.getTodaysHabits() }
    
    var hasLatestUpdates: Bool{
        return !updatingList.isEmpty
    }
    
    init(dateHelper: DateHelperProtocol = DateHelper()){
        self.dateHelper = dateHelper
        setupDataManagerObservers()
    }
    
    private func setupDataManagerObservers() {
        // Subscribe to habit changes from centralized data manager
        dataManager.$habits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshId = UUID()
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
            
        dataManager.$report
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshId = UUID()
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    public static func getTodayViewModel(report: Report?, habits: [HabitElement]) -> UpdateViewModel{
        // This method is now just for compatibility - actual data comes from centralized manager
        let viewModel = UpdateViewModel()
        return viewModel
    }
         
}

extension UpdateViewModel{
    func formattedToday()->String{
        return dataManager.getFormattedToday()
    }
    
    func addUpdatedHabit(habitName: String, completed: Bool){
        if updatingList.contains(where: { $0.name == habitName }) {
            updatingList.removeAll(where: { $0.name == habitName })
            return
        }
        self.updatingList.append(HabitElement(name: habitName, icon: nil, completed: completed))
        
        // Update the centralized data manager
       // dataManager.updateHabitStatus(habitName: habitName, isCompleted: completed)
    }
    
    func clearUpdatedList(){
        self.updatingList.removeAll()
    }
    
    func prepareTodayHabit(){
        self.showAllHabits = true
        DispatchQueue.main.async {
            self.refreshId = UUID()
        }
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
                self?.dataManager.fetchAllData()
                self?.updateChanges(habits: list.habits)
                self?.refreshId = UUID()
            case .failure(let error):
                if error == .authRequired {
                    self?.logout()
                }
                print("Failed to update habit: \(error.localizedDescription)")
            }
        }
            
    }
    func updateChanges(habits: [HabitClass]){
        habits.forEach { habit in
            dataManager.updateHabitStatus(habitName: habit.name, isCompleted: habit.complete)
        }
    }
}


