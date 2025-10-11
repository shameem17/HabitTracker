//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Shameem on 11/10/25.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var habitName: String = ""
    @State private var selectedIcon: String = "star.fill"
    @State private var showingIconPicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add New Habit")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Create a new habit to track your progress")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Form
                VStack(spacing: 20) {
                    // Habit Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Habit Name")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Enter habit name", text: $habitName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.body)
                    }
                    
                    // Icon Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Choose Icon")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            showingIconPicker = true
                        }) {
                            HStack {
                                Image(systemName: selectedIcon)
                                    .font(.system(size: 24))
                                    .foregroundColor(.primary)
                                    .frame(width: 40)
                                
                                Text("Tap to choose icon")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        saveHabit()
                    }) {
                        Text("Add Habit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(habitName.isEmpty ? .gray : .blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(habitName.isEmpty)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding(20)
        }
        .sheet(isPresented: $showingIconPicker) {
            IconPickerView(selectedIcon: $selectedIcon)
        }
    }
    
    private func saveHabit() {
        // Here you would typically save the habit using your service layer
        // For now, we'll just dismiss the view
        print("Saving habit: \(habitName) with icon: \(selectedIcon)")
        dismiss()
    }
}

#Preview {
    AddHabitView()
}
