//
//  IconPickerView.swift
//  HabitTracker
//
//  Created by Shameem on 11/10/25.
//

import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    // Comprehensive list of popular SF Symbols for habits
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
        "figure.mind.and.body", "peacesign", "om",
        
        // Time & Schedule
        "clock.fill", "alarm.fill", "timer", "calendar", "calendar.circle.fill",
        "bell.fill", "hourglass", "stopwatch.fill",
        
        // Creative & Hobbies
        "paintbrush.fill", "music.note", "guitar", "pianokeys", "mic.fill",
        "camera.fill", "photo.fill", "film.fill", "gamecontroller.fill",
        "puzzlepiece.fill", "theatermasks.fill", "hammer.fill",
        
        // Nature & Environment
        "tree.fill", "leaf.fill", "snowflake", "flame.fill", "bolt.fill",
        "cloud.sun.fill", "rainbow", "globe.americas.fill", "mountain.2.fill",
        "water.waves", "sun.and.horizon.fill",
        
        // Communication & Social
        "message.fill", "phone.fill", "video.fill", "person.2.fill",
        "heart.text.square.fill", "hand.wave.fill", "megaphone.fill",
        
        // Finance & Money
        "dollarsign.circle.fill", "creditcard.fill", "banknote.fill",
        "chart.line.uptrend.xyaxis", "percent", "plus.minus",
        
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
    
    private var filteredIcons: [String] {
        if searchText.isEmpty {
            return allIcons
        } else {
            return allIcons.filter { icon in
                icon.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 5)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search icons...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.bottom)
                
                // Icons Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(filteredIcons, id: \.self) { icon in
                            Button(action: {
                                selectedIcon = icon
                                dismiss()
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: icon)
                                        .font(.system(size: 24))
                                        .foregroundColor(selectedIcon == icon ? .white : .primary)
                                        .frame(width: 50, height: 50)
                                        .background(selectedIcon == icon ? .blue : .gray.opacity(0.1))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    Text(icon.replacingOccurrences(of: ".fill", with: ""))
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                
                if filteredIcons.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        
                        Text("No icons found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Try searching with different keywords")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .navigationTitle("Choose Icon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                if !selectedIcon.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                        .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    IconPickerView(selectedIcon: .constant("star.fill"))
}