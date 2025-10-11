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
    @Published var report: Report?
    @Published var habits: [HabitElement] = []
    @Published var showContent: Bool = false
    @Published var showAllHabits: Bool = false
    @Published var reportDict: [ReportData] = []
    private var todayReport: ReportElement?
    
    private var dateHelper: DateHelperProtocol
    
    init(apiService: HomeServiceProtocol = HomeService(),
         dateHelper: DateHelperProtocol = DateHelper()) {
        self.apiService = apiService
        self.dateHelper = dateHelper
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
               // print("smm report is \(report)")
            case .failure(let error):
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
                    self?.showAllHabits = true
                    self?.habits = habitResponse.habits ?? []
                }
            case .failure(let error):
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
            let undoneCount = reportDict[date]?[1] ?? totalCount()
            result[date] = [doneCount, undoneCount]
        }
        let x = result.sorted { lhs, rhs in
            lhs.key < rhs.key
        }
        for item in x {
            let date = item.key
            let d = item.value[0]
            let u = item.value[1]
            let day = self.dateHelper.getDayName(date: date)
            let data = ReportData(date: date, day: day, done: d, undone: u)
            self.reportDict.append(data)
        }
//        print("smm reportDict is \(self.reportDict)")
    }
    
}
