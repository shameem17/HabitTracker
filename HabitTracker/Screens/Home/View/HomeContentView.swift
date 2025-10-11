//
//  ContentView.swift
//  HabitTracker
//
//  Created by Shameem on 31/8/25.
//

import SwiftUI
import Charts

struct HomeContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var progress: Double = 0.0
    
    var body: some View {
        ScrollView {
            ActivityRingCard(progress: $progress, total: viewModel.totalCount(), done: viewModel.doneUndoneCount().done)
            
            HStack{
                Spacer()
                ContentCard(item: self.viewModel.reportDict,
                            barColor: .green, done: true)
                Spacer()
                ContentCard(item: self.viewModel.reportDict,
                            barColor: .red, done: false)
                Spacer()
            }.padding(.horizontal, 20)
                .padding(.top, 10)
            
            LineChartView(data: self.viewModel.reportDict, max: viewModel.totalCount())
            
            
        }
        .onAppear {
            withAnimation(.spring(duration: 1.5)) {
                progress = viewModel.getTodayProgress()
            }
        }
    }
}
