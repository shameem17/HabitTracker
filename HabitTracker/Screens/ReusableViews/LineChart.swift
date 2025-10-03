//
//  LineChart.swift
//  HabitTracker
//
//  Created by Shameem on 3/10/25.
//
import SwiftUI
import Charts

struct LineChartView: View {
    var data: [ReportData]
    var max: Int
    var body: some View {
        Chart(data) { item in
            LineMark(
                x: .value("Day", item.date ?? ""),
                y: .value("Habits", item.done ?? 0)
            )
            
            .foregroundStyle(.blue.gradient)
            .symbol(.circle) // add dots at each point
        }
        .chartYScale(domain: 0...max)
        .chartXAxis {
            AxisMarks { value in
                if let date = value.as(String.self) {
                    AxisValueLabel {
                        Text(date)
                            .rotationEffect(.degrees(-90)) // vertical labels
                            .fixedSize()
                    }
                }
            }
        }
        .frame(height: 200)
        .padding()
    }
}
