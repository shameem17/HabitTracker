//
//  AppHomeView.swift
//  HabitTracker
//
//  Created by Shameem on 30/9/25.
//

import SwiftUI

struct HomeView: View {
    // private var
    @State private var selected = 0
    @State private var showingAddHabit = false
    @EnvironmentObject var themeManager: ThemeManager
    internal let viewHelper = ViewHelper()
    @StateObject internal var viewModel: HomeViewmodel = HomeViewmodel()
    @State var showProfile: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    HomeHeaderView(dateText: self.viewModel.formattedToday(),
                                   title: self.viewModel.getPageTitle(for: selected), showProfile: $showProfile)
                    
                    // Main Content Area
                    if selected == 0 {
                        if viewModel.apiLoding {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                                .scaleEffect(2)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                       else if viewModel.totalCount() == 0 && !viewModel.apiLoding {
                            EmptyStateView()
                        } else {
                            HomeScreen
                        }
                    } else if selected == 1 {
                        TodayView(viewModel: viewModel.getTodayViewModel())
                    } else if selected == 2 {
                        SettingsView()
                    }
                    
                    BottomNav(selected: $selected)
                }
                
                // Floating Action Button (only show on today tab)
                if selected == 1 {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                showingAddHabit = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 56, height: 56)
                                    .background(.blue)
                                    .clipShape(Circle())
                                    .shadow(radius: 8)
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 100) // Position above bottom nav
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showProfile) {
                ProfileView()
            }
        }
        .navigationBarHidden(true)
       
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView()
        }
        .task {
            viewModel.getReport()
            viewModel.getHabits()
        }
    }
}


