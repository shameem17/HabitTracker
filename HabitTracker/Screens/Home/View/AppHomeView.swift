//
//  AppHomeView.swift
//  HabitTracker
//
//  Created by Shameem on 30/9/25.
//

import SwiftUI

struct AppHomeView: View {
    // private var
    @State private var selected = 0
    private let viewHelper = ViewHelper()
    @StateObject private var viewModel: ViewModel = ViewModel()
    var body: some View {
        VStack {
            Spacer()
            if selected == 0 {
                VStack(alignment: .leading){
                      
                      HomeHeaderView(dateText: self.viewModel.formattedToday())
                      if viewModel.apiLoding {
                          ProgressView()
                              .progressViewStyle(CircularProgressViewStyle(tint: .green))
                              .scaleEffect(2)
                              .frame(maxWidth: .infinity, maxHeight: .infinity)
                      }
                      if viewModel.showContent{
                          ContentView(viewModel: viewModel)
                          
                      }
                      
                  }
            } else if selected == 1 {
                Text("Statistics View")
                    .font(.largeTitle)
                    .bold()
            } else if selected == 2 {
                Text("Settings View")
                    .font(.largeTitle)
                    .bold()
            }
            BottomNav(selected: $selected)
            
        }
        .ignoresSafeArea(edges: .bottom)
        .task {
            viewModel.getReport()
        }
    }
}

extension AppHomeView{
    
}
