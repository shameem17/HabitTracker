//
//  HomeHeaderView.swift
//  HabitTracker
//
//  Created by Shameem on 29/9/25.
//

import SwiftUI

struct HomeHeaderView: View {
    var dateText: String
    var title: String
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(dateText)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text(title)
                    .bold()
                    .font(.largeTitle)
            }
            Spacer()
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 4) // optional border
                )
                .shadow(radius: 10)
                .onTapGesture {
                    print("smm profile open")
                }
        }
        .padding(.horizontal, 24)
    }
}
