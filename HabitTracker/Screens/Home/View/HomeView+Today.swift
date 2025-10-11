//
//  HomeView+Today.swift
//  HabitTracker
//
//  Created by Shameem on 11/10/25.
//

import SwiftUI

extension HomeView{
    var TodayView: some View{
        VStack(alignment: .leading, spacing: 16){
            Text("Today")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)
        }
    }
}

