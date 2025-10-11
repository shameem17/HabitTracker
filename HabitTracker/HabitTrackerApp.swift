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
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.currentTheme.colorScheme)
        }
    }
}
