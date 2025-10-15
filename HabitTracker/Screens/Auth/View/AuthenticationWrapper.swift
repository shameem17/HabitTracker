//
//  AuthenticationWrapper.swift
//  HabitTracker
//
//  Created by Shameem on 15/10/25.
//

import SwiftUI

struct AuthenticationWrapper: View {
    @StateObject private var authViewModel = AuthViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                // Main App Content
                HomeView()
                    .environmentObject(authViewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            } else {
                // Authentication Flow
                LoginView()
                    .environmentObject(authViewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: authViewModel.isAuthenticated)
    }
}

#Preview {
    AuthenticationWrapper()
        .environmentObject(ThemeManager())
}