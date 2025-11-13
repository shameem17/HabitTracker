//
//  TodayView.swift
//  HabitTracker
//
//  Created by Shameem on 18/10/25.
//

import SwiftUI

struct UpdateView: View {
    @StateObject internal var viewModel: UpdateViewModel
    
    var body: some View{
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Habtis for Today \(viewModel.formattedToday())")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
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
                            .font(.openSansTitle2)
                            .fontWeight(.semibold)
                        
                        Text("Add your first habit to start tracking your progress")
                            .font(.openSansBody)
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
                    Spacer()
                    HStack(spacing: 12) {
                        Button(action: {
                            //saveHabit()
                            print("update habits")
                            viewModel.updateHabit()
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else{
                                Text("Update Habit")
                                    .font(.openSansHeadline)
                                  
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(viewModel.hasLatestUpdates ? .blue : .gray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .disabled(!viewModel.hasLatestUpdates)
                        
                        Button(action: {
                            //dismiss()
                            print("clear")
                            viewModel.clearUpdatedList()
                        }) {
                            Text("Cancel")
                                .font(.openSansHeadline)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .onAppear {
            if !viewModel.habits.isEmpty {
                viewModel.prepareTodayHabit()
            }
        }
    }
    
    private func updateHabitStatus(habit: HabitElement, isCompleted: Bool) {
        // Here you would typically update the habit status via API
        print("Habit '\(habit.name ?? "")' completion status changed to: \(isCompleted)")
        viewModel.addUpdatedHabit(habitName: habit.name ?? "", completed: isCompleted)
    }
}
