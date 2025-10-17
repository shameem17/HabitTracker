//
//  ViewModel.swift
//  HabitTracker
//
//  Created by Shameem on 22/9/25.
//
import Foundation



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


final class ViewModel: ObservableObject{
    let apiService: HomeServiceProtocol
    @Published var apiLoding: Bool = false
    @Published var errorMessage: String?
    private var report: Report?
    @Published var habits: [HabitElement] = []
    @Published var showContent: Bool = false
    @Published var showAllHabits: Bool = false
    @Published var reportDict: [ReportData] = []
    private var todayReport: ReportElement?
    private var alreadyLoggedOut: Bool = false
    private var dateHelper: DateHelperProtocol
    @Published private var updatingList: [HabitElement] = []
    var hasLatestUpdates: Bool{
        return !updatingList.isEmpty
    }
    
    init(apiService: HomeServiceProtocol = HomeService(),
         dateHelper: DateHelperProtocol = DateHelper()) {
        self.apiService = apiService
        self.dateHelper = dateHelper
    }
    
    func getData(){
        getReport()
    }
        
    
    func getReport(){
        self.resetLoading(loading: true)
        apiService.getReport(day: "7"){[weak self] result in
            self?.resetLoading(loading: false)
            switch result{
            case .success(let report):
                DispatchQueue.main.async{
                    self?.report = report
                    self?.getTodayReport()
                    self?.buildLast7DaysDict(from: report)
                    self?.showContent = true
                }
            case .failure(let error):
                if error == .authRequired{
                    self?.logout()
                }
                print("error is \(error)")
            }
        }
    }
    func getHabits(){
        self.resetLoading(loading: true)
        apiService.getHabits {[weak self] result in
            self?.resetLoading(loading: false)
            switch result{
            case .success(let habitResponse):
                DispatchQueue.main.async{
                    //self?.showAllHabits = true
                    self?.habits = habitResponse.habits ?? []
                }
            case .failure(let error):
                if error == .authRequired{
                    self?.logout()
                }
                print("error is \(error)")
            }
        }
    }
    func formattedToday()->String{
        return dateHelper.getTodayDate()
    }
    
    func getTodayProgress()->Double{
        if todayReport == nil{
            return 0.001
        }
        let doneCount = Double(todayReport?.done ?? 0)
        let undoneCount = Double(todayReport?.undone ?? 0)
        return Double(doneCount/(doneCount + undoneCount))
    }
    func doneUndoneCount()->(done: Int, undone: Int){
        if todayReport == nil{
            return (0,self.report?.totalHabitCount ?? 0)
        }
        return (todayReport?.done ?? 0, todayReport?.undone ?? 0)
    }
    
    private func resetLoading(loading: Bool){
        DispatchQueue.main.async{[weak self] in
            self?.apiLoding = loading
        }
    }
}

extension ViewModel{
    private func getTodayReport(){
        guard let report = report?.report else { return }
        let filterReport = report.filter( {
            dateHelper.isDateToday(date: $0.date ?? "")
        })
        todayReport = filterReport.first
    }
    func totalCount()->Int{
        return report?.totalHabitCount ?? 0
    }
    
    func isHabitsEmpty() -> Bool {
        habits.forEach{ habit in
            print("Habit: \(habit.name ?? "no name"), ID: \(habit.icon ?? "no icon")") // Example property access
        }
        return habits.isEmpty
    }
    
    func getHabitsCount() -> Int {
        return habits.count
    }
}

extension ViewModel{
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

extension ViewModel{
   private func daysPassedInCurrentMonth() -> Int {
        let calendar = Calendar.current
        let today = Date()
        return calendar.component(.day, from: today)
    }
    func buildLast7DaysDict(from apiResponse: Report) {
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
    }
    
    func get7DaysReport() -> [ReportData] {
        if reportDict.count >= 7 {
            return Array(reportDict.suffix(7))
        } else {
            return reportDict
        }
    }
    
}
extension ViewModel{
    func logout(){
        if !alreadyLoggedOut{
            alreadyLoggedOut = true
            NotificationCenter.default.post(name: .logout, object: nil)
        }
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
        print("today = \(today?.date ?? "no date"), \(dateHelper.getTodayDate())")
        habits = habits.map { habit in
            var updatedHabit = habit
            if let todayHabits = today?.habits,
               let matched = todayHabits.first(where: { $0.name == habit.name }) {
                updatedHabit.completed = matched.completed
            } else {
                print("no matched habit for: \(habit.name ?? "no name")")
                updatedHabit.completed = false
            }
            return updatedHabit
        }
        self.resetLoading(loading: false)
        self.showAllHabits = true
        print("updated habits: \(habits)")
    }
}
