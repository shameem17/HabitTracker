//
//  EmptyStateView.swift
//  HabitTracker
//
//  Created by Shameem on 16/10/25.
//

import SwiftUI

struct EmptyStateView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var iconScale: CGFloat = 0.8
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Empty State Icon with animated glow
            ZStack {
                // Outer glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(hex: "667eea").opacity(0.3),
                                Color(hex: "764ba2").opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 100
                        )
                    )
                    .frame(width: 160, height: 160)
                    .blur(radius: 10)
                
                // Main circle with gradient
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(
                        color: Color(hex: "667eea").opacity(0.4),
                        radius: 20,
                        x: 0,
                        y: 10
                    )
                
                Image(systemName: "target")
                    .font(.system(size: 52, weight: .bold))
                    .foregroundColor(.white)
            }
            .scaleEffect(iconScale)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    iconScale = 1.0
                }
            }
            
            // Empty State Text
            VStack(spacing: 16) {
                Text("No Habits Yet")
                    .font(.poppinsLargeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Start building better habits today!")
                    .font(.poppinsTitle3)
                    .foregroundColor(.primary)
                
                Text("Tap the + button on the Today tab to create your first habit.")
                    .font(.poppinsBody)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 32)
            }
            
            // Motivational Message Card
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "f093fb"), Color(hex: "f5576c")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Text("Pro Tip")
                        .font(.poppinsHeadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "f093fb"), Color(hex: "f5576c")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                
                Text("Start small with habits like drinking water or reading for 5 minutes daily")
                    .font(.poppinsBody)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 12)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .background(
                ZStack {
                    // Glassmorphic background
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(colorScheme == .dark ? Color(.systemGray6).opacity(0.3) : Color.white.opacity(0.9))
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                    
                    // Subtle gradient overlay
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "f093fb").opacity(0.1),
                                    Color(hex: "f5576c").opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color(hex: "f093fb").opacity(0.3),
                                Color(hex: "f5576c").opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(
                color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.08),
                radius: 12,
                x: 0,
                y: 6
            )
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView()
}
