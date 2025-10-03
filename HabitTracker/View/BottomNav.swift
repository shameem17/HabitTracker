//
//  BottomNav.swift
//  HabitTracker
//
//  Created by Shameem on 29/9/25.
//

import SwiftUI

struct BottomNav: View {
    @Binding var selected: Int
    
    private let viewHelper = ViewHelper()
    var body: some View {
        HStack {
            Button(action: { selected = 0 }) {
                VStack(alignment: .center) {
                    Image(systemName: self.viewHelper.getTabBarIconName(currentSelected: selected, for: 0))
                        .font(.system(size: 24))
                        .foregroundColor(self.viewHelper.getTabBarColor(currentSelected: selected, for: 0))
                    Text("Home")
                        .font(.body)
                }
            }
            Spacer()
            Button(action: { selected = 1 }) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 24))
                    .foregroundColor(selected == 1 ? .blue : .white)
            }
            Spacer()
            Button(action: { selected = 2 }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24))
                    .foregroundColor(selected == 2 ? .blue : .white)
            }
        }
        .padding()
        .frame(height: 80)
        .background(.ultraThinMaterial) // glass effect
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .padding(.horizontal, 20)
        .shadow(radius: 10)
        
    }
    
}
