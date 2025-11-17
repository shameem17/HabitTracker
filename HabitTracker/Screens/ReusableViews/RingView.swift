//
//  RingView.swift
//  HabitTracker
//
//  Created by Shameem on 31/8/25.
//
import SwiftUI

struct ActivityRingView<S: ShapeStyle>: View {
    var progress: Double       // 0.0 → 1.0
    var ringColor: S
    var ringWidth: CGFloat
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: ringWidth
                )
            
            // Progress Circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(ringColor, style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
        }
        .onAppear{
            print("RingView appeared with progress: \(progress)")
        }
    }
}
