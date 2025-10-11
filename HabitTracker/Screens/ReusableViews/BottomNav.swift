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
                    Image(systemName: "house.fill")
                        .font(.system(size: 24))
                        .foregroundColor(selected == 0 ? .primary : .secondary)
                    Text("Home")
                        .font(.body)
                        .foregroundColor(selected == 0 ? .primary : .secondary)
                }
            }
            Spacer()
            
            Button(action: { selected = 1 }) {
                VStack(alignment: .center) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 24))
                        .foregroundColor(selected == 1 ? .primary : .secondary)
                    Text("Stats")
                        .font(.body)
                        .foregroundColor(selected == 1 ? .primary : .secondary)
                }
            }
            Spacer()
            
            Button(action: { selected = 2 }) {
                VStack(alignment: .center) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                        .foregroundColor(selected == 2 ? .primary : .secondary)
                    Text("Settings")
                        .font(.body)
                        .foregroundColor(selected == 2 ? .primary : .secondary)
                }
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
