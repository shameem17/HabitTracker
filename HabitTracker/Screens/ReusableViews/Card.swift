//
//  Card.swift
//  HabitTracker
//
//  Created by Shameem on 3/10/25.
//
import SwiftUI

struct ContentCard: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: HomeViewmodel
    var barColor: Color
    var done: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with gradient background
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(done ? "Completed" : "Pending")")
                        .font(.poppinsCustomBold(size: 15))
                        .foregroundStyle(
                            LinearGradient(
                                colors: done ? [Color(hex: "11998e"), Color(hex: "38ef7d")] : [Color(hex: "667eea"), Color(hex: "764ba2")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text(done ? "Great progress!" : "Keep going")
                        .font(.poppinsCaption)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 16)
                
                Spacer()
                
                // Animated icon with gradient background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: done ? [Color(hex: "11998e"), Color(hex: "38ef7d")] : [Color(hex: "667eea"), Color(hex: "764ba2")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                        .shadow(color: (done ? Color(hex: "11998e") : Color(hex: "667eea")).opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: done ? "checkmark.circle.fill" : "clock.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                }
                .padding(.trailing, 16)
            }
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            // Modern divider
            Divider()
                .background(
                    LinearGradient(
                        colors: [barColor.opacity(0.3), barColor.opacity(0.1)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.horizontal, 16)
            
            // Chart section
            BarChartView(data: BarChartData(
                report: viewModel.get7DaysReport(),
                color: barColor,
                total: viewModel.totalCount(),
                done: done,
                max: viewModel.totalCount() + 2
            ))
            .padding(.horizontal, 12)
            .padding(.bottom, 16)
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
                                barColor.opacity(0.05),
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
                            barColor.opacity(0.3),
                            barColor.opacity(0.1)
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
    }
}
