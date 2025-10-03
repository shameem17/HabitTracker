//
//  ContentView.swift
//  HabitTracker
//
//  Created by Shameem on 31/8/25.
//

import SwiftUI
import Charts




struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var progress: Double = 0.0
    
    var body: some View {
        ScrollView {
            ActivityRingCard(progress: $progress, total: viewModel.totalCount(), done: viewModel.doneUndoneCount().done)
            
            HStack{
                Spacer()
                ContentCard(title: "Done",
                            item: self.viewModel.reportDict,
                            barColor: .green, done: true)
                Spacer()
                ContentCard(title: "Not Done",
                            item: self.viewModel.reportDict,
                            barColor: .red, done: false)
                Spacer()
            }.padding(.horizontal, 20)
                .padding(.top, 10)
            
            LineChartView(data: viewModel.reportDict, max: viewModel.totalCount())
            
            
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                progress = viewModel.getTodayProgress()
            }
            
            withAnimation(.spring(duration: 1.5)) {
                
            }
        }
    }
}

struct ActivityRingCard: View {
    @Binding var progress: Double
    var total: Int
    var done: Int
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Activity Summary")
                .multilineTextAlignment(.leading)
                .font(.title)
                .bold()
                .foregroundStyle(.primary)
                .padding(.leading, 24)
                .padding(.top, 16)
                .padding(.bottom, 8)
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .background(
                    .primary
                )
                .padding(.bottom, 16)
            HStack{
                Spacer()
                ActivityRingView(progress: progress, ringColor: .red, ringWidth: 24)
                    .frame(width: 120, height: 120)
                Spacer()
                VStack(alignment: .leading){
                    Text("Today Report")
                        .font(.title2)
                        .bold()
                    Text("\(done)/\(total) Completed")
                        .font(.headline)
                        .foregroundStyle(.red.opacity(0.9))
                    
                }
                Spacer()
            }
            .padding(.bottom, 30)
            
        }
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .padding(.horizontal, 20)
    }
}

struct ContentCard: View {
    var title: String
    var item: [ReportData]
    var barColor: Color
    var done: Bool
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("\(title)")
                    .multilineTextAlignment(.leading)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.primary)
                    .padding(.leading, 10)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                Spacer()
                Image(systemName: "arrowtriangle.right.fill")
                    .foregroundStyle(barColor)
                    .font(.title)
                    .padding(.trailing, 10)
                
            }
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .background(
                    .primary
                )
                .padding(.bottom, 8)
            BarChartView(data: item, color: barColor, done: done)
            
            
        }
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}




struct HabitData: Identifiable {
    let id = UUID()
    let day: String
    let value: Int
}

struct BarChartView: View {
    var data: [ReportData]
    var color: Color
    var done: Bool
    
    var body: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Day", item.day ?? "date"),
                y: .value("Habits", done ? item.done ?? 0 : item.undone ?? 0)
            )
            .foregroundStyle(color.gradient)
        }
        .chartXAxis{
            AxisMarks { value in
                if let date = value.as(String.self) {
                    AxisValueLabel {
                        Text(date)
                            .rotationEffect(.degrees(-90))
                            .fixedSize()
                    }
                }
            }
        }
        .frame(height: 120)
        .padding()
    }
    
}

struct LineChartView: View {
    var data: [ReportData]
    var max: Int
    var body: some View {
        Chart(data) { item in
            LineMark(
                x: .value("Day", item.date ?? ""),
                y: .value("Habits", item.done ?? 0)
            )
            
            .foregroundStyle(.blue.gradient)
            .symbol(.circle) // add dots at each point
        }
        .chartYScale(domain: 0...max)
        .chartXAxis {
            AxisMarks { value in
                if let date = value.as(String.self) {
                    AxisValueLabel {
                        Text(date)
                            .rotationEffect(.degrees(-90)) // vertical labels
                            .fixedSize()
                    }
                }
            }
        }
        .frame(height: 200)
        .padding()
    }
}

#Preview {
    AppHomeView()
}
