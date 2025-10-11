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
    var done: Bool
    var max: Int
}

struct BarChartView: View {
    var data: BarChartData
    
    var body: some View {
        Chart(data.report) { item in
            BarMark(
                x: .value("Day", item.day ?? "date"),
                y: .value("Habits", data.done ? item.done ?? 0 : item.undone ?? 0)
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
