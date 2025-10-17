//
//  BarChart.swift
//  HabitTracker
//
//  Created by Shameem on 3/10/25.
//
import SwiftUI
import Charts

struct BarChartData{
    var report: [ReportData]
    var color: Color
    var total: Int
    var done: Bool
    var max: Int
    
    func count(item: ReportData) -> Int{
        print("smm \(done), count = \(self.done ? item.done ?? 0 : self.total - (item.done ?? 0))")
        return self.done ? item.done ?? 0 : self.total - (item.done ?? 0)
    }
}

struct BarChartView: View {
    var data: BarChartData
    
    var body: some View {
        Chart(data.report) { item in
            BarMark(
                x: .value("Day", item.day ?? "date"),
                y: .value("Habits", data.count(item: item))
            )
            .foregroundStyle(data.color.gradient)
        }
        .chartYScale(domain: 0...data.max)
        .chartXAxis{
            AxisMarks { value in
                if let date = value.as(String.self) {
                    AxisValueLabel {
                        Text(date)
                            .rotationEffect(.degrees(-90))
                            .fixedSize()
                    }
                }
            }
        }
        .frame(height: 120)
        .padding()
    }
    
}
