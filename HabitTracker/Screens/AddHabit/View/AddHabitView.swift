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
    @StateObject private var viewModel = AddHabitViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
               Header
                
                // Form
                VStack(spacing: 20) {
                    FromFields
                    
                    // Icon Selection
                    IconSelector
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        saveHabit()
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }else{
                            Text("Add Habit")
                                .font(.poppinsHeadline)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(habitName.isEmpty ? .gray : .blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(habitName.isEmpty)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .font(.poppinsHeadline)
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
            IconPickerView(selectedIcon: $selectedIcon, allIcons: viewModel.getAllIcons())
        }
    }
    
    private func saveHabit() {
        print("Saving habit: \(habitName) with icon: \(selectedIcon)")
        viewModel.addHabit(name: habitName, icon: selectedIcon)
       
    }
}

extension AddHabitView{
    var Header: some View{
        VStack(alignment: .leading, spacing: 8) {
            Text("Add New Habit")
                .font(.poppinsLargeTitle)
                .bold()
            
            Text("Create a new habit to track your progress")
                .font(.poppinsSubheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension AddHabitView{
    var FromFields: some View{
        VStack(alignment: .leading, spacing: 8) {
            Text("Habit Name")
                .font(.poppinsHeadline)
                .foregroundColor(.primary)
            
            TextField("Enter habit name", text: $habitName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.poppinsBody)
                .autocapitalization(.words)
                .disableAutocorrection(true)
        }
    }
}

extension AddHabitView{
    var IconSelector: some View{
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Icon")
                .font(.poppinsHeadline)
                .foregroundColor(.primary)
            
            Button(action: {
                showingIconPicker = true
            }) {
                HStack {
                    Image(systemName: selectedIcon)
                        .font(.poppinsMedium)
                        .foregroundColor(.primary)
                        .frame(width: 40)
                    
                    Text("Tap to choose icon")
                        .font(.poppinsBody)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.poppinsFootnote)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
