//
//  Card.swift
//  HabitTracker
//
//  Created by Shameem on 3/10/25.
//
import SwiftUI

struct ContentCard: View {
    var item: [ReportData]
    var barColor: Color
    var done: Bool
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("\(done ? "Done" : "Not Done")")
                    .multilineTextAlignment(.leading)
                    .font(.footnote)
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
            BarChartView(data: BarChartData(report: item,
                                            color: barColor,
                                            done: done, max: 6))
            //BarChartView(data: item, color: barColor, done: done)
            
            
        }
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}
