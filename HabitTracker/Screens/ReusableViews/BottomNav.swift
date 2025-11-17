//
//  BottomNav.swift
//  HabitTracker
//
//  Created by Shameem on 29/9/25.
//

import SwiftUI

struct BottomNav: View {
    @Binding var selected: Int
    @Namespace var animation
    @Environment(\.colorScheme) var colorScheme
    
    private let viewHelper = ViewHelper()
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(
                title: "Home",
                icon: "house.fill",
                isSelected: selected == 0,
                animation: animation
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selected = 0
                }
            }
            
            TabButton(
                title: "Today",
                icon: "checkmark.circle.fill",
                isSelected: selected == 1,
                animation: animation
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selected = 1
                }
            }
            
            TabButton(
                title: "Settings",
                icon: "gearshape.fill",
                isSelected: selected == 2,
                animation: animation
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selected = 2
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    colorScheme == .dark
                    ? Color(hex: "1C1C1E").opacity(0.95)
                        : Color.white.opacity(0.95)
                )
                .shadow(
                    color: colorScheme == .dark
                        ? Color.white.opacity(0.1)
                        : Color.black.opacity(0.08),
                    radius: 20,
                    x: 0,
                    y: -5
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            colorScheme == .dark
                                ? Color.white.opacity(0.1)
                                : Color.black.opacity(0.05),
                            lineWidth: 1
                        )
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
}

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let animation: Namespace.ID
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 48, height: 48)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                            .shadow(
                                color: Color(hex: "667eea").opacity(0.4),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .secondary)
                }
                .frame(height: 48)
                
                Text(title)
                    .font(.poppinsCustomRegular(size: 11))
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
