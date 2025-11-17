//
//  LineChart.swift
//  HabitTracker
//
//  Created by Shameem on 3/10/25.
//
import SwiftUI
import Charts

struct LineChartView: View {
    @Environment(\.colorScheme) var colorScheme
    var data: [ReportData]
    var max: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Chart(data) { item in
                // Area gradient beneath the line
                AreaMark(
                    x: .value("Day", item.date ?? ""),
                    y: .value("Habits", item.done ?? 0)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(hex: "667eea").opacity(0.3),
                            Color(hex: "764ba2").opacity(0.1),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // Line mark with gradient
                LineMark(
                    x: .value("Day", item.date ?? ""),
                    y: .value("Habits", item.done ?? 0)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .interpolationMethod(.catmullRom)
                
                // Points with gradient
                PointMark(
                    x: .value("Day", item.date ?? ""),
                    y: .value("Habits", item.done ?? 0)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .symbolSize(80)
            }
            .chartYScale(domain: 0...max)
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    if let date = value.as(String.self) {
                        AxisValueLabel {
                            Text(date)
                                .font(.poppinsCaption)
                                .foregroundColor(.secondary)
                                .rotationEffect(.degrees(-45))
                        }
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [2, 2]))
                            .foregroundStyle(Color.gray.opacity(0.2))
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue)")
                                .font(.poppinsCaption)
                                .foregroundColor(.secondary)
                        }
                    }
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [2, 2]))
                        .foregroundStyle(Color.gray.opacity(0.2))
                }
            }
            .frame(height: 220)
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(
            ZStack {
                // Glassmorphic background
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(colorScheme == .dark ? Color(.systemGray6).opacity(0.3) : Color.white.opacity(0.9))
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                
                // Subtle gradient overlay
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "667eea").opacity(0.05),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color(hex: "667eea").opacity(0.3),
                            Color(hex: "764ba2").opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(
            color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 6
        )
        .padding(.horizontal, 20)
    }
}
