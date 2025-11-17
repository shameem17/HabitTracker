//
//  DaySliderView.swift
//  HabitTracker
//
//  Created by AI Assistant
//

import SwiftUI

struct DaySliderView: View {
    var selectedDate: Date  // Changed to accept Date directly, not Binding
    let onPreviousDay: () -> Void
    let onNextDay: () -> Void
    let onGoToToday: () -> Void
    let canGoToNextDay: Bool
    let isToday: Bool
    
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating = false
    
    // Gradient colors
    private var primaryGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "667eea"),
                Color(hex: "764ba2")
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var disabledGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.gray.opacity(0.5),
                Color.gray.opacity(0.5)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var successGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "11998e"),
                Color(hex: "38ef7d")
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var borderGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "667eea").opacity(0.3),
                Color(hex: "764ba2").opacity(0.3)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(hex: "1a1a2e").opacity(0.6) : Color.white.opacity(0.8)
    }
    
    private var cardShadowColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.3) : Color(hex: "667eea").opacity(0.1)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                // Previous Day Button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        onPreviousDay()
                        isAnimating = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isAnimating = false
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(primaryGradient)
                        .clipShape(Circle())
                        .shadow(
                            color: Color(hex: "667eea").opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                }
                .scaleEffect(isAnimating ? 0.95 : 1.0)
                
                // Date Display
                VStack(spacing: 4) {
                    Text(isToday ? "Today" : formattedDate())
                        .font(.poppinsSemiBold(size: 18))
                        .foregroundColor(colorScheme == .dark ? .white : Color(hex: "1a1a2e"))
                    
                    if !isToday {
                        Text(formattedDateSubtitle())
                            .font(.poppinsRegular(size: 13))
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : Color(hex: "1a1a2e").opacity(0.6))
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Next Day Button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        onNextDay()
                        isAnimating = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isAnimating = false
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(canGoToNextDay ? .white : .white.opacity(0.5))
                        .frame(width: 44, height: 44)
                        .background(canGoToNextDay ? primaryGradient : disabledGradient)
                        .clipShape(Circle())
                        .shadow(
                            color: canGoToNextDay ? Color(hex: "667eea").opacity(0.3) : Color.clear,
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                }
                .disabled(!canGoToNextDay)
                .scaleEffect(isAnimating ? 0.95 : 1.0)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(cardBackgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(borderGradient, lineWidth: 1)
                    )
                    .shadow(color: cardShadowColor, radius: 12, x: 0, y: 6)
            )
            
            // Go to Today Button (only show when not on today)
            if !isToday {
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        onGoToToday()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Back to Today")
                            .font(.poppinsSemiBold(size: 13))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(successGradient)
                    .clipShape(Capsule())
                    .shadow(
                        color: Color(hex: "11998e").opacity(0.3),
                        radius: 6,
                        x: 0,
                        y: 3
                    )
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Helper Methods
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: selectedDate)
    }
    
    private func formattedDateSubtitle() -> String {
        let calendar = Calendar.current
        let today = Date()
        
        if calendar.isDateInYesterday(selectedDate) {
            return "Yesterday"
        } else if calendar.isDateInTomorrow(selectedDate) {
            return "Tomorrow"
        } else {
            let daysAgo = calendar.dateComponents([.day], from: selectedDate, to: today).day ?? 0
            if daysAgo > 0 {
                return "\(daysAgo) day\(daysAgo == 1 ? "" : "s") ago"
            } else if daysAgo < 0 {
                return "In \(abs(daysAgo)) day\(abs(daysAgo) == 1 ? "" : "s")"
            }
            return ""
        }
    }
}

// MARK: - Preview
struct DaySliderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DaySliderView(
                selectedDate: Date(),
                onPreviousDay: {},
                onNextDay: {},
                onGoToToday: {},
                canGoToNextDay: true,
                isToday: true
            )
            .padding()
            
            DaySliderView(
                selectedDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                onPreviousDay: {},
                onNextDay: {},
                onGoToToday: {},
                canGoToNextDay: true,
                isToday: false
            )
            .padding()
        }
    }
}
