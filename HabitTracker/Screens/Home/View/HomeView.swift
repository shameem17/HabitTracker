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
    internal let viewHelper = ViewHelper()
    @StateObject internal var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HomeHeaderView(dateText: self.viewModel.formattedToday(),
                               title: self.viewModel.getPageTitle(for: selected))
                if selected == 0 {
                     HomeScreen
                } else if selected == 1 {
                    TodayView
                } else if selected == 2 {
                    Text("Settings View")
                        .font(.largeTitle)
                        .bold()
                }
                
                BottomNav(selected: $selected)
            }
            
            // Floating Action Button
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
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView()
        }
        .task {
            viewModel.getReport()
        }
    }
}


#Preview{
    HomeView()
}
