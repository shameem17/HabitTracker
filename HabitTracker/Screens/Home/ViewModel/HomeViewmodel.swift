//
//  ViewModel.swift
//  HabitTracker
//
//  Created by Shameem on 22/9/25.
//
import Foundation
import Combine



struct ReportData: Identifiable{
    let id = UUID()
    let date: String?
    let day: String?
    let done: Int?
    let undone: Int?
}

enum HomeTab: Int, CaseIterable {
    case summary = 0
    case today = 1
    case settings = 2
}


final class HomeViewmodel: ObservableObject{
    // Use centralized data manager instead of local properties
    private let dataManager = HabitDataManager.shared
    @Published var showContent: Bool = false
    @Published var reportDict: [ReportData] = []
    @Published var isEmpty: Bool = true
    private var alreadyLoggedOut: Bool = false
    private var dateHelper: DateHelperProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // Computed properties that reference centralized data
    var apiLoding: Bool {
        get{
            dataManager.isLoading
        }
        set{
            dataManager.isLoading = newValue
        }
        
    }
    var errorMessage: String? { dataManager.errorMessage }
    var habits: [HabitElement] { dataManager.habits }
    var report: Report? { dataManager.report }
    
    init(dateHelper: DateHelperProtocol = DateHelper()) {
        self.dateHelper = dateHelper
        // Subscribe to data manager changes
        setupDataManagerObservers()
    }
    
    private func setupDataManagerObservers() {
        dataManager.$habits
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
            
        dataManager.$report
            .receive(on: DispatchQueue.main)
            .sink { [weak self] report in
                if let report = report {
                    self?.buildLast7DaysDict(from: report)
                    self?.showContent = true
                }
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
            
        dataManager.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func getData(){
        dataManager.fetchAllData()
    }
    
    func getReport(){
        dataManager.fetchReport()
    }
    
    func getHabits(){
        dataManager.fetchHabits()
    }
    
    // Add method to refresh habits after adding new ones
    func refreshHabitsAfterAdd() {
        dataManager.fetchHabits()
    }
    
    func formattedToday()->String{
        return dataManager.getFormattedToday()
    }
    
    func getTodayProgress()->Double{
        return dataManager.getTodayProgress()
    }
    
    func doneUndoneCount()->(done: Int, undone: Int){
        return dataManager.getDoneUndoneCount()
    }
}

extension HomeViewmodel{
    func totalCount()->Int{
        return dataManager.totalHabitCount
    }
    func isHabitsEmpty() -> Bool {
        return dataManager.isHabitsEmpty()
    }
    
    func getHabitsCount() -> Int {
        return dataManager.getHabitsCount()
    }
    
    func getTodayViewModel() -> UpdateViewModel {
        return UpdateViewModel.getTodayViewModel(report: dataManager.report, habits: dataManager.habits)
    }
}

extension HomeViewmodel{
    func getPageTitle(for selected: Int) -> String {
        switch selected {
        case 0:
            return "Habits Summary"
        case 1:
            return "Today's Habits"
        case 2:
            return "Settings"
        default:
            return "Habit"
        }
    }
}

extension HomeViewmodel{
   private func daysPassedInCurrentMonth() -> Int {
        let calendar = Calendar.current
        let today = Date()
        return calendar.component(.day, from: today)
    }
    func buildLast7DaysDict(from apiResponse: Report) {
        self.apiLoding = true
        self.reportDict = []
        var result: [String: [Int]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current

        // Build last 7 days array
        let today = Date()
        let calendar = Calendar.current
        let daysInThisMonth = self.daysPassedInCurrentMonth()
        let last7Days: [String] = (0..<daysInThisMonth).compactMap {
            let date = calendar.date(byAdding: .day, value: -$0, to: today)!
            return dateFormatter.string(from: date)
        }
        guard let reports = apiResponse.report else{
            return
        }
        let reportDict = Dictionary(uniqueKeysWithValues: reports.map { ($0.date, [$0.done, $0.undone]) })

        for date in last7Days {
            let doneCount = reportDict[date]?[0] ?? 0
            let undoneCount =  totalCount() - doneCount
            result[date] = [doneCount, undoneCount]
        }
        let x = result.sorted { lhs, rhs in
            lhs.key < rhs.key
        }
        for item in x {
            let date = item.key
            let d = item.value[0]
            let u = self.totalCount() - d
            let day = self.dateHelper.getDayName(date: date)
            let data = ReportData(date: date, day: day, done: d, undone: u)
            self.reportDict.append(data)
        }
        self.apiLoding = false
    }
    
    func get7DaysReport() -> [ReportData] {
        if reportDict.count >= 7 {
            return Array(reportDict.suffix(7))
        } else {
            return reportDict
        }
    }
    
}
extension HomeViewmodel{
    func logout(){
        if !alreadyLoggedOut{
            alreadyLoggedOut = true
            NotificationCenter.default.post(name: .logout, object: nil)
        }
    }
   
}
