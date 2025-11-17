# 🎯 Habit Tracker

A modern, elegant iOS habit tracking application built with SwiftUI that helps users build better habits through beautiful visualizations and intuitive daily tracking.

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2015.0+-lightgrey.svg)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-blue.svg)

## ✨ Features

### 📊 **Activity Tracking & Visualization**
- **Daily Habit Tracking** - Mark habits as complete/incomplete with a single tap
- **Progress Ring** - Animated circular progress indicator with counting animation
- **7-Day Trend Chart** - Visual line chart showing habit completion trends
- **Activity Summary** - Real-time progress cards showing done/pending habits
- **Date Navigation** - Browse through your habit history day by day (7 days backward)

### ✅ **Habit Management**
- **Add Custom Habits** - Create habits with custom names and SF Symbol icons
- **Icon Picker** - Comprehensive SF Symbols library with 150+ categorized icons and search
- **Time-Based Habits** - Special support for "Bed Time" and "Wakeup Time" with time picker
- **Swipe to Delete** - Native iOS swipe gesture to remove habits
- **Update Habits** - Modify habit completion status for any selected date
- **Batch Updates** - Update multiple habits at once with "Update All" button

### 🔐 **Authentication & Security**
- **User Authentication** - Secure login and signup functionality
- **Token Management** - Automatic token refresh on 401/403 errors
- **Forgot Password** - Password reset flow with email instructions
- **Persistent Sessions** - User sessions maintained across app launches
- **Profile Management** - View user profile with logout functionality

### 🎨 **Modern Design & UI/UX**
- **Glassmorphic Design** - Semi-transparent cards with blur effects
- **Gradient Themes** - Beautiful purple-blue and teal-green color gradients
- **Dark Mode Support** - Fully adaptive light/dark theme with elegant transitions
- **Custom Fonts** - Poppins and OpenSans fonts for modern typography
- **Animated Splash Screen** - Professional app launch experience
- **Smooth Animations** - Spring-based transitions and counting animations
- **Empty States** - Helpful onboarding messages for new users

### 📱 **Navigation & Organization**
- **Tab-Based Navigation** - Summary, Today's Habits, and Settings tabs
- **Day Slider** - Quick navigation between dates with "Back to Today" button
- **Date Paginator** - Navigate through habit history with previous/next buttons
- **Profile Screen** - Full-screen user profile with back navigation
- **Modal Sheets** - Add habit and forgot password flows

### 📄 **Reporting & Export**
- **PDF Export** - Generate and share habit reports as PDF documents
- **iOS Share Sheet** - Save PDFs to Files, AirDrop, email, or cloud storage
- **Report History** - Access habit completion data for historical dates

## 🛠 Frameworks & Technologies

### **Core Frameworks**
- **SwiftUI** - Modern declarative UI framework for iOS
- **Combine** - Reactive programming for data flow and state management
- **Foundation** - Core iOS functionality and utilities

### **Networking**
- **URLSession** - Network requests and API communication
- **JSONSerialization** - JSON encoding/decoding for API data
- **Custom Network Layer** - Centralized networking service with retry logic

### **Data Management**
- **UserDefaults** - Local storage for user preferences and tokens
- **Singleton Pattern** - Centralized data manager (`HabitDataManager`)
- **MVVM Architecture** - Clean separation of concerns with ViewModels

### **UI Components**
- **Custom Charts** - Line charts and progress rings built with SwiftUI shapes
- **SF Symbols** - Apple's extensive icon library
- **GeometryReader** - Responsive layouts and dynamic sizing
- **LazyVStack** - Performance-optimized scrollable lists

### **Design System**
- **Custom Color Extensions** - Hex color support (`Color(hex: "667eea")`)
- **Reusable Modifiers** - `.modernCard()`, `.glassmorphic()` for consistent styling
- **Theme Management** - Centralized design constants and gradients

### **Authentication & Security**
- **Token-Based Auth** - JWT access and refresh tokens
- **Secure Storage** - UserDefaults for token persistence
- **Auto Token Refresh** - Automatic retry mechanism on auth failures

## 🏗 Architecture

### **MVVM (Model-View-ViewModel)**
```
├── Models/
│   ├── Habit.swift
│   ├── Report.swift
│   ├── User.swift
│   └── API Request/Response Models
├── Views/
│   ├── HomeView.swift
│   ├── UpdateView.swift
│   ├── AddHabitView.swift
│   ├── LoginView.swift
│   └── Reusable Components
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── UpdateViewModel.swift
│   ├── AddHabitViewModel.swift
│   └── AuthViewModel.swift
├── Services/
│   ├── NetworkService.swift
│   ├── HabitDataManager.swift
│   ├── AuthService.swift
│   └── PDFGeneratorService.swift
└── Extensions/
    ├── Color+Hex.swift
    ├── Font+Poppins.swift
    └── Font+OpenSans.swift
```

### **Key Design Patterns**
- **Singleton** - `HabitDataManager.shared` for centralized state
- **Protocol-Oriented** - Service protocols for testability
- **Dependency Injection** - ViewModels injected via `@StateObject` and `@EnvironmentObject`
- **Observer Pattern** - `@Published` properties with Combine for reactive updates
- **Router Pattern** - API endpoint management with custom routers

## 🎯 Key Features Breakdown

### **Centralized Data Management**
All habit and report data is managed through `HabitDataManager.shared`:
- Single source of truth for app state
- Automatic synchronization across all views
- Reactive updates using Combine publishers
- Efficient API call management with caching

### **Smart API Integration**
- Automatic token refresh on authentication failures
- Retry mechanism with exponential backoff
- Thread-safe network operations with proper QoS
- Background processing with main thread UI updates

### **Modern Animations**
- Discrete counting animation (1, 2, 3... 40%)
- Spring-based button presses and transitions
- Matched geometry effects for tab transitions
- Smooth gradient transitions

## 📦 Installation

1. Clone the repository
2. Open `HabitTracker.xcodeproj` in Xcode
3. Build and run on iOS 15.0+ simulator or device

## 🎨 Design Philosophy

The app follows a modern, elegant design language with:
- **Glassmorphism** for depth and hierarchy
- **Gradient accents** for visual interest
- **Neumorphism-inspired** shadows and elevation
- **Minimalist** interface with focus on content
- **Smooth animations** for delightful interactions

## 🚀 Future Enhancements

- Push notifications for habit reminders
- Habit streaks and achievements
- Social sharing and challenges
- Widget support for home screen
- Apple Watch companion app
- iCloud sync across devices

## 📄 License

This project is a personal habit tracking application.

---

**Built with ❤️ using SwiftUI**
