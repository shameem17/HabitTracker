//
//  BarChart.swift
//  HabitTracker
//
//  Created by Shameem on 3/10/25.
//
import SwiftUI
import Charts

struct BarChartView: View {
    var data: [ReportData]
    var color: Color
    var done: Bool
    
    var body: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Day", item.day ?? "date"),
                y: .value("Habits", done ? item.done ?? 0 : item.undone ?? 0)
            )
            .foregroundStyle(color.gradient)
        }
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
