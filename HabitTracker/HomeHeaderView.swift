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
    @Binding var showProfile: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(dateText)
                    .font(.poppinsSubheadline)
                    .foregroundStyle(.secondary)
                    .fontWeight(.medium)
                
                Text(title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            
            Spacer()
            
            Button(action: {
                showProfile = true
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "667eea").opacity(0.9), Color(hex: "764ba2").opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                }
                .shadow(
                    color: Color(hex: "667eea").opacity(colorScheme == .dark ? 0.4 : 0.25),
                    radius: 12,
                    x: 0,
                    y: 6
                )
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}

//// Custom button style for smooth press animation
//struct ScaleButtonStyle: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
//            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
//    }
//}
