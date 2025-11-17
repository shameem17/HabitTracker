//
//  AppHomeView.swift
//  HabitTracker
//
//  Created by Shameem on 30/9/25.
//

import SwiftUI

struct HomeView: View {
    // State variables
    @State private var selected = 0
    @State private var showingAddHabit = false
    @State private var showProfile: Bool = false
    
    // Environment objects
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    
    // ViewModels
    internal let viewHelper = ViewHelper()
    @StateObject internal var viewModel: HomeViewmodel = HomeViewmodel()
    
    // Use centralized data manager
    @StateObject private var dataManager = HabitDataManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Modern gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        colorScheme == .dark ? Color(hex: "1a1a2e") : Color(hex: "f8f9fa"),
                        colorScheme == .dark ? Color(hex: "16213e") : Color(hex: "e9ecef")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HomeHeaderView(
                        dateText: self.viewModel.formattedToday(),
                        title: self.viewModel.getPageTitle(for: selected),
                        showProfile: $showProfile
                    )
                    
                    // Main Content Area
                    if selected == 0 {
                        if viewModel.apiLoding {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "667eea")))
                                .scaleEffect(2)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        else if viewModel.totalCount() == 0 && viewModel.showContent {
                            EmptyStateView()
                        } else if viewModel.showContent {
                            HomeScreen
                        }
                        else {
                            Spacer()
                        }
                    } else if selected == 1 {
                        UpdateView(viewModel: UpdateViewModel())
                    } else if selected == 2 {
                        SettingsView()
                    }
                    
                    // Bottom Navigation
                    BottomNav(selected: $selected)
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
            dataManager.fetchAllData()
        }
    }
}


