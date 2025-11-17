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
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                // Splash Screen
                SplashScreenView()
                    .transition(.opacity)
            } else if authViewModel.isAuthenticated {
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
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: authViewModel.isAuthenticated)
        .onAppear {
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    AuthenticationWrapper()
        .environmentObject(ThemeManager())
}
