//
//  RingView.swift
//  HabitTracker
//
//  Created by Shameem on 31/8/25.
//
import SwiftUI

struct ActivityRingView: View {
    var progress: Double       // 0.0 → 1.0
    var ringColor: Color
    var ringWidth: CGFloat
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(ringColor.opacity(0.2), style: StrokeStyle(lineWidth: ringWidth))
            
            // Progress Circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(ringColor, style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1.0), value: progress)
        }
        .onAppear{
            print("RingView appeared with progress: \(progress)")
        }
    }
}

