//
//  SettingsView.swift
//  HabitTracker
//
//  Created by Shameem on 11/10/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Customize your app experience")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Appearance Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "paintbrush.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            
                            Text("Appearance")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 20)
                        
                        // Theme Options
                        VStack(spacing: 12) {
                            ForEach(AppTheme.allCases, id: \.self) { theme in
                                ThemeOptionRow(
                                    theme: theme,
                                    isSelected: themeManager.currentTheme == theme
                                ) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        themeManager.currentTheme = theme
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                                .frame(width: 30)
                            
                            Text("About")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            SettingsRow(
                                icon: "app.badge",
                                title: "Version",
                                value: "1.0.0",
                                showChevron: false
                            )
                            
                            SettingsRow(
                                icon: "heart.fill",
                                title: "Made with SwiftUI",
                                value: "",
                                showChevron: false
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 100) // Extra space for bottom navigation
                }
            }
        }
    }
}

// MARK: - Theme Option Row
struct ThemeOptionRow: View {
    let theme: AppTheme
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Theme Icon
                Image(systemName: theme.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .primary)
                    .frame(width: 50, height: 50)
                    .background(isSelected ? .blue : .gray.opacity(0.2))
                    .clipShape(Circle())
                
                // Theme Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.displayName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(getThemeDescription(theme))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Selection Indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .padding(16)
            .background(.gray.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .blue.opacity(0.3) : .clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getThemeDescription(_ theme: AppTheme) -> String {
        switch theme {
        case .system:
            return "Matches your device settings"
        case .light:
            return "Always use light appearance"
        case .dark:
            return "Always use dark appearance"
        }
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String
    let showChevron: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.secondary)
                .frame(width: 30)
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            if !value.isEmpty {
                Text(value)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SettingsView()
}
