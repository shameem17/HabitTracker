//
//  DatePaginatorView.swift
//  HabitTracker
//
//  Created by AI Assistant on 16/11/25.
//

import SwiftUI

struct DatePaginatorView: View {
    @ObservedObject var viewModel: UpdateViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
           
            HStack(spacing: 20) {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.goToPreviousDay()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                viewModel.canGoToPreviousDay() ?
                                LinearGradient(
                                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .shadow(
                                color: viewModel.canGoToPreviousDay() ? Color(hex: "667eea").opacity(0.4) : Color.clear,
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                        
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(ScaleButtonStyle())
                
                Spacer()
                
                // Date display with modern design
                VStack(spacing: 6) {
                    Text(viewModel.getFormattedSelectedDate())
                        .font(.poppinsCustomBold(size: 13))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    if !viewModel.isToday() {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.goToToday()
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.uturn.left.circle.fill")
                                    .font(.system(size: 12))
                                Text("Back to Today")
                                    .font(.poppinsCaption)
                            }
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "11998e"), Color(hex: "38ef7d")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(hex: "11998e").opacity(0.1),
                                                Color(hex: "38ef7d").opacity(0.1)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                
                Spacer()
                
                // Next day button with gradient or disabled state
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.goToNextDay()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                viewModel.canGoToNextDay() ?
                                LinearGradient(
                                    colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .shadow(
                                color: viewModel.canGoToNextDay() ? Color(hex: "667eea").opacity(0.4) : Color.clear,
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(viewModel.canGoToNextDay() ? .white : .gray.opacity(0.6))
                    }
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(!viewModel.canGoToNextDay())
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                ZStack {
                    // Glassmorphic background
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(colorScheme == .dark ? Color(.systemGray6).opacity(0.3) : Color.white.opacity(0.9))
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                    
                    // Subtle gradient overlay
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "667eea").opacity(0.03),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color(hex: "667eea").opacity(0.2),
                                Color(hex: "764ba2").opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.06),
                radius: 10,
                x: 0,
                y: 4
            )
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
        }
    }
}

// Custom button style for scale animation
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
