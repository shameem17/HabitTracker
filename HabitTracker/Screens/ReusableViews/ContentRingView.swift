//
//  RingView.swift
//  HabitTracker
//
//  Created by Shameem on 3/10/25.
//

import SwiftUI

struct ActivityRingCard: View {
    @Binding var progress: Double
    var total: Int
    var done: Int
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Activity Summary")
                .multilineTextAlignment(.leading)
                .font(.openSansTitle)
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
                        .font(.openSansTitle2)
                        .bold()
                    Text("\(done)/\(total) Completed")
                        .font(.openSansHeadline)
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

