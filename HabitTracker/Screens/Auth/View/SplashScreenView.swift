//
//  SplashScreenView.swift
//  HabitTracker
//
//  Created by AI Assistant on 17/11/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // App Logo/Icon - You can replace this with your SVG
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.0 : 0.6)
                    .opacity(isAnimating ? 1.0 : 0.3)
                
                // App Name
                Text("Habit Tracker")
                    .font(.poppinsLargeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(isAnimating ? 1.0 : 0)
                
                // Tagline
                Text("Build Better Habits")
                    .font(.poppinsSubheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(isAnimating ? 1.0 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
