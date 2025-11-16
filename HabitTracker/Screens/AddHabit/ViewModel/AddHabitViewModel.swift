//
//  AddHabitViewModel.swift
//  HabitTracker
//
//  Created by Shameem on 11/10/25.
//

import Foundation

final class AddHabitViewModel: ObservableObject{
    // MARK: - Published Properties
    @Published var habitName: String = ""
    @Published var selectedIcon: String = "star.fill"
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccess: Bool = false
    @Published var isHabitAdded: Bool = false
    weak var addHabitDelegate: AddNewHabitProtocol?
    
    private let apiService: AddHabitProtocol = AddHabitService()
    // MARK: - Private Properties

    
    private let allIcons = [
        // Health & Fitness
        "heart.fill", "heart", "lungs.fill", "brain.head.profile", "dumbbell.fill",
        "figure.walk", "figure.run", "bicycle", "sportscourt.fill", "tennisball.fill",
        "basketball.fill", "football.fill", "soccerball", "volleyball.fill",
        
        // Food & Drink
        "cup.and.saucer.fill", "wineglass.fill", "waterbottle.fill", "drop.fill",
        "leaf.fill", "carrot.fill", "apple.logo", "mug.fill",
        
        // Productivity & Learning
        "book.fill", "book.closed.fill", "graduationcap.fill", "pencil",
        "pencil.circle.fill", "keyboard.fill", "laptopcomputer", "desktopcomputer",
        "studentdesk", "backpack.fill", "briefcase.fill",
        
        // Wellness & Mindfulness
        "moon.fill", "moon.zzz.fill", "sun.max.fill", "sun.dust.fill",
        "cloud.rain.fill", "sparkles", "leaf.arrow.circlepath",
        "figure.mind.and.body", "peacesign",
        
        // Time & Schedule
        "clock.fill", "alarm.fill", "timer", "calendar", "calendar.circle.fill",
        "bell.fill", "hourglass", "stopwatch.fill",
        
        // Creative & Hobbies
        "paintbrush.fill", "music.note", "pianokeys", "mic.fill",
        "camera.fill", "photo.fill", "film.fill", "gamecontroller.fill",
        "puzzlepiece.fill", "theatermasks.fill", "hammer.fill",
        
        // Nature & Environment
        "tree.fill", "leaf.fill", "snowflake", "flame.fill", "bolt.fill",
        "cloud.sun.fill", "rainbow", "globe.americas.fill", "mountain.2.fill",
        "water.waves", "sun.and.horizon.fill", "guitars.fill",
        
        // Communication & Social
        "message.fill", "phone.fill", "video.fill", "person.2.fill",
        "heart.text.square.fill", "hand.wave.fill", "megaphone.fill",
        
        // Finance & Money
        "dollarsign.circle.fill", "creditcard.fill", "banknote.fill",
        "chart.line.uptrend.xyaxis", "percent", "plusminus.circle.fill",
        
        // Travel & Transportation
        "car.fill", "airplane", "bicycle", "tram.fill", "ferry.fill",
        "map.fill", "location.fill", "compass.drawing", "suitcase.fill",
        
        // Technology
        "iphone", "applewatch", "airpods", "headphones", "speaker.fill",
        "wifi", "antenna.radiowaves.left.and.right", "battery.100",
        
        // Stars & Achievements
        "star.fill", "star.circle.fill", "rosette", "trophy.fill",
        "medal.fill", "crown.fill", "target", "checkmark.circle.fill",
        
        // Symbols & Shapes
        "circle.fill", "square.fill", "triangle.fill", "diamond.fill",
        "hexagon.fill", "heart.circle.fill", "infinity", "plus.circle.fill",
        "minus.circle.fill", "multiply.circle.fill", "flag.fill",
        
        // Animals (for fun habit categories)
        "hare.fill", "tortoise.fill", "dog.fill", "cat.fill", "bird.fill",
        "fish.fill", "ladybug.fill", "ant.fill",
        
        // Home & Lifestyle
        "house.fill", "bed.double.fill", "sofa.fill", "lamp.table.fill",
        "shower.fill", "toilet.fill", "washer.fill", "refrigerator.fill",
        "oven.fill", "microwave.fill", "dishwasher.fill"
    ]
}

extension AddHabitViewModel{
    func getAllIcons()->[String]{
        return self.allIcons
    }
}

extension AddHabitViewModel{
    // MARK: - Validation
    
    // MARK: - API Methods
    @MainActor
    func addHabit(name: String, icon: String) {
        
        isLoading = true
        clearErrors()
        showSuccess = false
        apiService.addHabit(name: name, icon: icon) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(_):
                print("Habit added successfully")
                self?.showSuccess = true
                self?.updateList(name: name, icon: icon)
            case .failure(let error):
                print("Failed to add habit: \(error.localizedDescription)")
            }
        }
        
        
    }
    
    private func updateList(name: String, icon: String){
        DispatchQueue.main.async{[weak self] in
            //self?.updateVM.addNewHabit(name: name, icon: icon)
            self?.addHabitDelegate?.addNewHabit(name: name, icon: name)
        }
    }
    
    // MARK: - Helper Methods
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    private func clearErrors() {
        showError = false
        errorMessage = nil
    }
    
    private func clearForm() {
        habitName = ""
        selectedIcon = "star.fill"
    }
    
    private func handleError(_ error: Error) {
        let message = switch error {
        case NetworkError.invalidURL:
            "Invalid request. Please try again."
        case NetworkError.requestFailed:
            "Network error. Please check your connection."
        case NetworkError.decodingFailed:
            "Failed to process response. Please try again."
        case NetworkError.unknown:
            "An unexpected error occurred."
        default:
            error.localizedDescription
        }
        
        showErrorMessage(message)
    }
}
