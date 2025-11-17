//
//  RingView.swift
//  HabitTracker
//
//  Created by Shameem on 3/10/25.
//

import SwiftUI

struct ActivityRingCard: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var progress: Double
    var total: Int
    var done: Int
    
    var progressPercentage: Int {
        Int(progress * 100)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with gradient text
            VStack(alignment: .leading, spacing: 4) {
                Text("Activity Summary")
                    .font(.poppinsTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Your daily progress")
                    .font(.poppinsCaption)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 20)
            .padding(.top, 20)
            
            // Modern divider
            Divider()
                .background(
                    LinearGradient(
                        colors: [Color(hex: "667eea").opacity(0.3), Color(hex: "764ba2").opacity(0.1)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.horizontal, 10)
            
            // Ring and stats section
            HStack(spacing: 12) {
                Spacer()
                
                // Enhanced activity ring with glow
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(hex: "667eea").opacity(0.2),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 50,
                                endRadius: 80
                            )
                        )
                        .frame(width: 140, height: 140)
                    
                    ActivityRingView(
                        progress: progress,
                        ringColor: LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        ringWidth: 20
                    )
                    .frame(width: 120, height: 120)
                    
                    // Center percentage
                    VStack(spacing: 2) {
                        Text("\(progressPercentage)%")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                }
                
                Spacer()
                
                // Stats section with modern design
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today's Report")
                        .font(.poppinsCustomBold(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    // Completion stats with gradient
                    HStack(spacing: 4) {
                        Text("\(done)")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "11998e"), Color(hex: "38ef7d")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("/\(total)")
                            .font(.poppinsTitle2)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("Completed")
                        .font(.poppinsCaption)
                        .foregroundColor(.secondary)
                    
                    // Progress indicator
                    HStack(spacing: 6) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(index < Int(progress * 3) ?
                                      LinearGradient(
                                        colors: [Color(hex: "11998e"), Color(hex: "38ef7d")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                      ) :
                                      LinearGradient(
                                        colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                      )
                                )
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.bottom, 20)
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
