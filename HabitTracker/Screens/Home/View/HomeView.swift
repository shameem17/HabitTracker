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
    // Use centralized data manager
    @StateObject private var dataManager = HabitDataManager.shared
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                
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
                        else if viewModel.totalCount() == 0 && viewModel.showContent {
                            EmptyStateView()
                       } else if viewModel.showContent{
                            HomeScreen
                        }
                        else{
                            Spacer()
                        }
                    } else if selected == 1 {
                        UpdateView(viewModel: UpdateViewModel())
                    } else if selected == 2 {
                        SettingsView()
                    }
                    
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


