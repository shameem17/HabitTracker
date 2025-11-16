//
//  HabitDataManager.swift
//  HabitTracker
//
//  Created by Shameem on 16/11/25.
//

import Foundation
import Combine

/// Centralized data manager for habits and reports
/// All ViewModels will use this shared instance to maintain data consistency
class HabitDataManager: ObservableObject {
    
    // MARK: - Singleton Instance
    static let shared = HabitDataManager()
    
    // MARK: - Published Properties
    @Published var habits: [HabitElement] = []
    @Published var report: Report?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private let homeService: HomeServiceProtocol
    private let dateHelper: DateHelperProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var totalHabitCount: Int {
        return report?.totalHabitCount ?? 0
    }
    
    var todayReport: ReportElement? {
        guard let reportElements = report?.report else { return nil }
        return reportElements.first { dateHelper.isDateToday(date: $0.date ?? "") }
    }
    
    // MARK: - Initialization
    private init(homeService: HomeServiceProtocol = HomeService(),
                 dateHelper: DateHelperProtocol = DateHelper()) {
        self.homeService = homeService
        self.dateHelper = dateHelper
    }
    
    // MARK: - Public Methods
    
    /// Fetch all data (habits and report) from API
    func fetchAllData() {
        fetchReport()
        fetchHabits()
    }
    
    /// Fetch report data from API
    func fetchReport() {
        setLoading(true)
        homeService.getReport(day: "7") { [weak self] result in
            DispatchQueue.main.async {
                self?.setLoading(false)
                switch result {
                case .success(let report):
                    self?.report = report
                    self?.errorMessage = nil
                    print("HabitDataManager: Report fetched successfully")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("HabitDataManager: Failed to fetch report - \(error)")
                    if error == .authRequired {
                        self?.handleAuthRequired()
                    }
                }
            }
        }
    }
    
    /// Fetch habits data from API
    func fetchHabits() {
        setLoading(true)
        homeService.getHabits { [weak self] result in
            DispatchQueue.main.async {
                self?.setLoading(false)
                switch result {
                case .success(let habitResponse):
                    self?.habits = habitResponse.habits ?? []
                    self?.errorMessage = nil
                    print("HabitDataManager: Habits fetched successfully. Count: \(self?.habits.count ?? 0)")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("HabitDataManager: Failed to fetch habits - \(error)")
                    if error == .authRequired {
                        self?.handleAuthRequired()
                    }
                }
            }
        }
    }
    
    /// Add a new habit to the central data
    func addHabit(_ habit: HabitElement) {
        DispatchQueue.main.async {
            // Add to habits array
            self.habits.append(habit)
            
            // Add to all report dates
            self.addHabitToAllReportDates(habit)
            
            print("HabitDataManager: Habit added locally. Total count: \(self.habits.count)")
        }
    }
    
    /// Update habit completion status
    func updateHabitStatus(habitName: String, isCompleted: Bool) {
        DispatchQueue.main.async {
            // Update in habits array
            if let index = self.habits.firstIndex(where: { $0.name == habitName }) {
                self.habits[index].completed = isCompleted
            }
            
            // Update in today's report
            self.updateTodayReport(habitName: habitName, isCompleted: isCompleted)
            
            print("HabitDataManager: Habit '\(habitName)' updated to \(isCompleted)")
        }
    }
    
    /// Remove a habit from central data
    func removeHabit(habitName: String) {
        DispatchQueue.main.async {
            // Remove from habits array
            self.habits.removeAll { $0.name == habitName }
            
            // Remove from all report dates
            self.removeHabitFromAllReportDates(habitName)
            
            print("HabitDataManager: Habit '\(habitName)' removed from central data")
        }
    }
    
    /// Get habits for today with completion status
    func getTodaysHabits() -> [HabitElement] {
        guard let todayHabits = todayReport?.habits else {
            return habits.map { habit in
                var updatedHabit = habit
                updatedHabit.completed = false
                return updatedHabit
            }
        }
        
        return habits.map { habit in
            var updatedHabit = habit
            if let matched = todayHabits.first(where: { $0.name == habit.name }) {
                updatedHabit.completed = matched.completed
            } else {
                updatedHabit.completed = false
            }
            return updatedHabit
        }
    }
    
    /// Get progress for today
    func getTodayProgress() -> Double {
        guard let todayReport = todayReport else { return 0.001 }
        let doneCount = Double(todayReport.done ?? 0)
        let totalCount = Double(self.totalHabitCount)
        return totalCount > 0 ? doneCount / totalCount : 0.001
    }
    
    /// Get done/undone count for today
    func getDoneUndoneCount() -> (done: Int, undone: Int) {
        guard let todayReport = todayReport else {
            return (0, totalHabitCount)
        }
        return (todayReport.done ?? 0, todayReport.undone ?? 0)
    }
    
    // MARK: - Private Methods
    
    private func setLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = loading
        }
    }
    
    private func addHabitToAllReportDates(_ habit: HabitElement) {
        guard let reportElements = report?.report else { return }
        
        for i in 0..<reportElements.count {
            let newHabitReport = HabitsReport(name: habit.name ?? "", completed: false)
            report?.report?[i].habits?.append(newHabitReport)
        }
    }
    
    private func removeHabitFromAllReportDates(_ habitName: String) {
        guard let reportElements = report?.report else { return }
        
        for i in 0..<reportElements.count {
            report?.report?[i].habits?.removeAll { $0.name == habitName }
        }
    }
    
    private func updateTodayReport(habitName: String, isCompleted: Bool) {
        guard let reportElements = report?.report else { return }
        
        for i in 0..<reportElements.count {
            if dateHelper.isDateToday(date: reportElements[i].date ?? "") {
                if let habitIndex = report?.report?[i].habits?.firstIndex(where: { $0.name == habitName }) {
                    report?.report?[i].habits?[habitIndex].completed = isCompleted
                }
                break
            }
        }
    }
    
    private func handleAuthRequired() {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
}

// MARK: - Convenience Methods
extension HabitDataManager {
    
    /// Refresh all data from API
    func refreshAllData() {
        fetchAllData()
    }
    
    /// Check if habits list is empty
    func isHabitsEmpty() -> Bool {
        return habits.isEmpty
    }
    
    /// Get habits count
    func getHabitsCount() -> Int {
        return habits.count
    }
    
    /// Get formatted today's date
    func getFormattedToday() -> String {
        return dateHelper.getTodayDate()
    }
    
    /// Get habits for a specific date with completion status
    func getHabits(for date: Date) -> [HabitElement] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
      
        guard let reportElements = report?.report,
              let reportForDate = reportElements.first(where: { $0.date == dateString }) else {
          
            return habits.map { habit in
                var updatedHabit = habit
                updatedHabit.completed = false
                return updatedHabit
            }
        }
        
        return habits.map { habit in
            var updatedHabit = habit
            if let matched = reportForDate.habits?.first(where: { $0.name == habit.name }) {
                updatedHabit.completed = matched.completed ?? false
            } else {
                updatedHabit.completed = false
            }
            return updatedHabit
        }
    }
}
