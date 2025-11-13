//
//  EmptyStateView.swift
//  HabitTracker
//
//  Created by Shameem on 16/10/25.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Empty State Icon
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.blue.opacity(0.1), .green.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "target")
                    .font(.poppinsCustomBold(size: 48))
                    .foregroundColor(.blue)
            }
            
            // Empty State Text
            VStack(spacing: 12) {
                Text("No Habits Yet")
                    .font(.poppinsLargeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Start building better habits today!\nTap the + button on the Today tab to create your first habit.")
                    .font(.poppinsBody)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
            // Motivational Message
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "lightbulb")
                        .font(.poppinsCaption)
                        .foregroundColor(.orange)
                    
                    Text("Pro Tip")
                        .font(.poppinsCaption)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                
                Text("Start small with habits like drinking water or reading for 5 minutes daily")
                    .font(.poppinsCaption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView()
}
