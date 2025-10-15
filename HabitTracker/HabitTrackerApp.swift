//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Shameem on 31/8/25.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            AuthenticationWrapper()
                .environmentObject(themeManager)
                .environmentObject(authViewModel)
                .preferredColorScheme(themeManager.currentTheme.colorScheme)
        }
    }
}
