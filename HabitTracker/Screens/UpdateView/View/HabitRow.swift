//
//  ModernHabitRowView.swift
//  HabitTracker
//
//  Created by AI Assistant on 17/11/25.
//

import SwiftUI

struct HabitRowView: View {
    @State var habit: HabitElement
    let onToggle: (Bool) -> Void
    
    @State private var selectedTime: Date = Date()
    @State private var showTimePicker: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    private var requiresTimeInput: Bool {
        guard let habitName = habit.name?.lowercased() else { return false }
        return habitName.contains("bed time") ||
               habitName.contains("wakeup time") ||
               habitName.contains("wake up time") ||
               habitName == "sleep" ||
               habitName == "wake"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Modern Habit Icon with gradient
                ZStack {
                    Circle()
                        .fill(
                            habit.isCompleted
                                ? LinearGradient(
                                    colors: [Color(hex: "11998e"), Color(hex: "38ef7d")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(
                                    colors: [
                                        colorScheme == .dark ? Color(hex: "2C2C2E") : Color(hex: "F5F5F7"),
                                        colorScheme == .dark ? Color(hex: "3C3C3E") : Color(hex: "E5E5E7")
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                        .frame(width: 56, height: 56)
                        .shadow(
                            color: habit.isCompleted
                                ? Color(hex: "11998e").opacity(0.3)
                                : Color.black.opacity(colorScheme == .dark ? 0.2 : 0.05),
                            radius: habit.isCompleted ? 12 : 6,
                            x: 0,
                            y: habit.isCompleted ? 6 : 3
                        )
                    
                    Image(systemName: habit.icon ?? "star.fill")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(habit.isCompleted ? .white : .primary.opacity(0.7))
                }
                
                // Habit Details
                VStack(alignment: .leading, spacing: 6) {
                    Text(habit.name ?? "Unnamed Habit")
                        .font(.poppinsHeadline)
                        .foregroundColor(.primary)
                        .strikethrough(habit.isCompleted && !requiresTimeInput)
                    
                    if requiresTimeInput {
                        if habit.isCompleted {
                            HStack(spacing: 4) {
                                Image(systemName: "clock.fill")
                                    .font(.caption2)
                                Text(timeFormatter.string(from: selectedTime))
                            }
                            .font(.caption)
                            .foregroundColor(Color(hex: "11998e"))
                        } else {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.caption2)
                                Text("Tap to set time")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                        }
                    } else {
                        Text(habit.isCompleted ? "Completed today!" : "Tap to mark as done")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Action Button with modern design
                if requiresTimeInput {
                    timeActionButton
                } else {
                    completionActionButton
                }
            }
            .padding(20)
            
            // Time Picker Section
            if requiresTimeInput && showTimePicker {
                timePickerSection
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(hex: "1C1C1E") : Color.white)
                .shadow(
                    color: colorScheme == .dark
                        ? Color.white.opacity(0.05)
                        : Color.black.opacity(0.06),
                    radius: 10,
                    x: 0,
                    y: 4
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    habit.isCompleted
                        ? Color(hex: "11998e").opacity(0.3)
                        : Color.clear,
                    lineWidth: 1.5
                )
        )
    }
    
    private var timeActionButton: some View {
        Button(action: {
            if habit.isCompleted {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showTimePicker.toggle()
                }
            } else {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showTimePicker = true
                    habit.completed = true
                    onToggle(true)
                }
            }
        }) {
            ZStack {
                Circle()
                    .fill(habit.isCompleted ? Color(hex: "11998e").opacity(0.15) : Color.gray.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: habit.isCompleted ? "clock.fill" : "clock")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(habit.isCompleted ? Color(hex: "11998e") : .gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var completionActionButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                habit.completed = !habit.isCompleted
                onToggle(habit.isCompleted)
            }
        }) {
            ZStack {
                Circle()
                    .fill(habit.isCompleted ? Color(hex: "11998e").opacity(0.15) : Color.gray.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(habit.isCompleted ? Color(hex: "11998e") : .gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var timePickerSection: some View {
        VStack(spacing: 16) {
            Divider()
                .padding(.horizontal, 20)
            
            HStack {
                Text("Select Time:")
                    .font(.poppinsSubheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                DatePicker(
                    "",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
            }
            .padding(.horizontal, 20)
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showTimePicker = false
                        if !habit.isCompleted {
                            onToggle(false)
                        }
                    }
                }
                .font(.poppinsSubheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button("Done") {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showTimePicker = false
                        habit.completed = true
                        onToggle(true)
                    }
                }
                .font(.poppinsSubheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "11998e"), Color(hex: "38ef7d")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(
                    color: Color(hex: "11998e").opacity(0.3),
                    radius: 8,
                    x: 0,
                    y: 4
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}
