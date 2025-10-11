//
//  HomeView+Today.swift
//  HabitTracker
//
//  Created by Shameem on 11/10/25.
//

import SwiftUI

extension HomeView{
    var TodayView: some View{
        VStack(spacing: 0) {
            if viewModel.apiLoding {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .green))
                    .scaleEffect(2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.showAllHabits {
                if viewModel.isHabitsEmpty() {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "list.bullet.clipboard")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No Habits Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Add your first habit to start tracking your progress")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Scrollable habits list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.habits, id: \.id) { habit in
                                HabitRowView(
                                    habit: habit
                                ) { isCompleted in
                                    updateHabitStatus(habit: habit, isCompleted: isCompleted)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 100) // Extra padding for floating button
                    }
                }
            }
        }
        .onAppear {
            // Fetch habits when the today view appears
            if viewModel.habits.isEmpty {
                viewModel.getHabits()
            }
        }
    }
    
    private func updateHabitStatus(habit: HabitElement, isCompleted: Bool) {
        // Here you would typically update the habit status via API
        print("Habit '\(habit.name ?? "")' completion status changed to: \(isCompleted)")
        
        // You can add API call here to update habit status
        // viewModel.updateHabitStatus(habitName: habit.name, isCompleted: isCompleted)
    }
}

// MARK: - Habit Row View
struct HabitRowView: View {
    let habit: HabitElement
    let onToggle: (Bool) -> Void
    
    @State private var isCompleted: Bool = false
    @State private var selectedTime: Date = Date()
    @State private var showTimePicker: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    // Helper to check if this habit requires time input
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
                // Habit Icon
                Image(systemName: habit.icon ?? "star.fill")
                    .font(.system(size: 24))
                    .foregroundColor(isCompleted ? .white : .primary)
                    .frame(width: 50, height: 50)
                    .background(isCompleted ? .green : .gray.opacity(0.2))
                    .clipShape(Circle())
                
                // Habit Name and Status
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name ?? "Unnamed Habit")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .strikethrough(isCompleted && !requiresTimeInput)
                    
                    if requiresTimeInput {
                        if isCompleted {
                            Text("Time: \(timeFormatter.string(from: selectedTime))")
                                .font(.caption)
                                .foregroundColor(.green)
                        } else {
                            Text("Tap to set time")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text(isCompleted ? "Completed today!" : "Tap to mark as done")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Action Button
                if requiresTimeInput {
                    Button(action: {
                        if isCompleted {
                            // If already set, show time picker to edit
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showTimePicker.toggle()
                            }
                        } else {
                            // First time setting, show picker and mark as completed
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showTimePicker = true
                                isCompleted = true
                                onToggle(true)
                            }
                        }
                    }) {
                        Image(systemName: isCompleted ? "clock.fill" : "clock")
                            .font(.system(size: 28))
                            .foregroundColor(isCompleted ? .green : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    // Regular completion toggle
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            isCompleted.toggle()
                            onToggle(isCompleted)
                        }
                    }) {
                        Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 28))
                            .foregroundColor(isCompleted ? .green : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(16)
            
            // Time Picker (appears when expanded)
            if requiresTimeInput && showTimePicker {
                VStack(spacing: 12) {
                    Divider()
                        .padding(.horizontal, 16)
                    
                    HStack {
                        Text("Select Time:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        DatePicker(
                            "",
                            selection: $selectedTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                    }
                    .padding(.horizontal, 16)
                    
                    HStack(spacing: 12) {
                        Button("Cancel") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showTimePicker = false
                                if !isCompleted {
                                    // If it wasn't completed before, revert
                                    onToggle(false)
                                }
                            }
                        }
                        .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button("Done") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showTimePicker = false
                                isCompleted = true
                                onToggle(true)
                                print("Time set for \(habit.name ?? ""): \(timeFormatter.string(from: selectedTime))")
                            }
                        }
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
                .background(timePickerBackgroundColor)
            }
        }
        .background(rowBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(rowBorderColor, lineWidth: isCompleted ? 1.5 : 0.5)
        )
        .scaleEffect(isCompleted ? 0.98 : 1.0)
        .shadow(color: shadowColor, radius: 2, x: 0, y: 1)
    }
    
    // Time formatter for display
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    // Dynamic colors based on theme and completion status
    private var rowBackgroundColor: Color {
        if isCompleted {
            return colorScheme == .dark ? Color(.systemGray6) : Color(.systemBackground)
        } else {
            return colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6)
        }
    }
    
    private var timePickerBackgroundColor: Color {
        return colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray5)
    }
    
    private var rowBorderColor: Color {
        if isCompleted {
            return .green.opacity(0.4)
        } else {
            return colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray4)
        }
    }
    
    private var shadowColor: Color {
        return colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.2)
    }
}
