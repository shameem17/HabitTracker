//
//  HomeHeaderView.swift
//  HabitTracker
//
//  Created by Shameem on 29/9/25.
//

import SwiftUI

struct HomeHeaderView: View {
    var dateText: String
    
    var body: some View {
        HStack{
            VStack{
                Text(dateText)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text("Habit Summary")
                    .bold()
                    .font(.largeTitle)
            }
            Spacer()
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 4) // optional border
                )
                .shadow(radius: 10)
        }
        .padding(.horizontal, 24)
    }
}
