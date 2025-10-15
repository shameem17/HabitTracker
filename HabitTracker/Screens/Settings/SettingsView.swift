//
//  SettingsView.swift
//  HabitTracker
//
//  Created by Shameem on 11/10/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showingLogoutAlert = false
    
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
                    // User Profile Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.purple)
                                .frame(width: 30)
                            
                            Text("Profile")
                                .font(.openSansHeadline)
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            if let user = authViewModel.currentUser {
                                SettingsRow(
                                    icon: "person.fill",
                                    title: "Name",
                                    value: user.name,
                                    showChevron: false
                                )
                                
                                SettingsRow(
                                    icon: "envelope.fill",
                                    title: "Email",
                                    value: user.email,
                                    showChevron: false
                                )
                            }
                            
                            // Logout Button
                            Button(action: {
                                showingLogoutAlert = true
                            }) {
                                HStack(spacing: 16) {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 18))
                                        .foregroundColor(.red)
                                        .frame(width: 30)
                                    
                                    Text("Sign Out")
                                        .font(.openSansBody)
                                        .foregroundColor(.red)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    colorScheme == .dark ? Color(.systemGray5) : Color(.systemBackground)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray5),
                                            lineWidth: 0.5
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Appearance Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "paintbrush.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            
                            Text("Appearance")
                                .font(.openSansHeadline)
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
                                .font(.openSansHeadline)
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
        .alert("Sign Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                Task {
                    await authViewModel.logout()
                }
            }
        } message: {
            Text("Are you sure you want to sign out?")
                .font(.openSansBody)
        }
    }
}

// MARK: - Theme Option Row
struct ThemeOptionRow: View {
    let theme: AppTheme
    let isSelected: Bool
    let onTap: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
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
                        .font(.openSansHeadline)
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
            .background(rowBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(rowBorderColor, lineWidth: isSelected ? 1.5 : 0.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Dynamic colors based on theme and selection status
    private var rowBackgroundColor: Color {
        if isSelected {
            return colorScheme == .dark ? Color(.systemGray6) : Color(.systemGray6)
        } else {
            return colorScheme == .dark ? Color(.systemGray5) : Color(.systemBackground)
        }
    }
    
    private var rowBorderColor: Color {
        if isSelected {
            return .blue.opacity(0.4)
        } else {
            return colorScheme == .dark ? Color(.systemGray4) : Color(.systemGray5)
        }
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
                .font(.openSansBody)
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


