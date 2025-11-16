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
        VStack(spacing: 12) {
            // Date navigation buttons
            HStack(spacing: 16) {
                // Previous day button
                Button(action: {
                    viewModel.goToPreviousDay()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.poppinsCustomRegular(size: 14))
                        .foregroundColor(viewModel.canGoToPreviousDay() ? .white : .gray)
                        .frame(width: 40, height: 40)
                        .background(viewModel.canGoToPreviousDay() ? Color.blue : Color.gray.opacity(0.3))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(viewModel.canGoToPreviousDay() ? 0.1 : 0), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // Date display
                VStack(spacing: 4) {
                    Text(viewModel.getFormattedSelectedDate())
                        .font(.poppinsCustomBold(size: 14))
                        .foregroundColor(.primary)
                    
                    if !viewModel.isToday() {
                        Button(action: {
                            viewModel.goToToday()
                        }) {
                            Text("Go to Today")
                                .font(.poppinsCaption)
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Spacer()
                
                // Next day button
                Button(action: {
                    viewModel.goToNextDay()
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(viewModel.canGoToNextDay() ? .white : .gray)
                        .frame(width: 40, height: 40)
                        .background(viewModel.canGoToNextDay() ? Color.blue : Color.gray.opacity(0.3))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(viewModel.canGoToNextDay() ? 0.1 : 0), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!viewModel.canGoToNextDay())
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : Color(UIColor.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
            .padding(.horizontal, 16)
        }
    }
}
