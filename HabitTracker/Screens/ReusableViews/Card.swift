//
//  Card.swift
//  HabitTracker
//
//  Created by Shameem on 3/10/25.
//
import SwiftUI

struct ContentCard: View {
    @ObservedObject var viewModel: ViewModel
    var barColor: Color
    var done: Bool
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("\(done ? "Done" : "Not Done")")
                    .multilineTextAlignment(.leading)
                    .font(.openSansFootnote)
                    .foregroundStyle(.primary)
                    .padding(.leading, 10)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                Spacer()
                Image(systemName: "arrowtriangle.right.fill")
                    .foregroundStyle(barColor)
                    .font(.openSansTitle)
                    .padding(.trailing, 10)
                
            }
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .background(
                    .primary
                )
                .padding(.bottom, 8)
            BarChartView(data: BarChartData(report: viewModel.get7DaysReport(),
                                            color: barColor, total: viewModel.totalCount(),
                                            done: done, max: viewModel.totalCount() + 2))
        
            
            
        }
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}
