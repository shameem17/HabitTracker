//
//  TodayView.swift
//  HabitTracker
//
//  Created by Shameem on 18/10/25.
//

import SwiftUI

struct UpdateView: View {
    @StateObject internal var viewModel: UpdateViewModel
    @State private var showingAddHabit = false
    var body: some View{
        ZStack{
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Habits")
                        .font(.poppinsTitle3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 5)
                
                // Date Paginator
                DatePaginatorView(viewModel: viewModel)
                    .padding(.vertical, 6)
                
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
                                .font(.poppinsTitle2)
                                .fontWeight(.semibold)
                            
                            Text("Add your first habit to start tracking your progress")
                                .font(.poppinsBody)
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
                            .id(viewModel.refreshId)
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
                                        .font(.poppinsHeadline)
                                    
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background( !viewModel.hasLatestUpdates ?   LinearGradient(
                                gradient: Gradient(colors: [
                                    .gray
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :   LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "667eea"),
                                    Color(hex: "764ba2")
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .disabled(!viewModel.hasLatestUpdates)
                            
                            Button(action: {
                                //dismiss()
                                print("clear")
                                viewModel.clearUpdatedList()
                            }) {
                                Text("Cancel")
                                    .font(.poppinsHeadline)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                    }
                }
                else{
                    Spacer()
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                        Button(action: {
                            showingAddHabit = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "667eea"),
                                            Color(hex: "764ba2")
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(color: Color(hex: "667eea").opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 60)
                    }
            }
        }
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView()
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
