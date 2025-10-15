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
    
    var allIcons: [String]
    
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
                SearchBar
                
                // Icons Grid
                IconGrid
                
                //empty icon
                if filteredIcons.isEmpty{
                    EmptyIconView
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
extension IconPickerView{
    var SearchBar: some View{
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search icons...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .autocorrectionDisabled()
                .autocapitalization(.none)
        }
        .padding()
        .background(.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
        .padding(.bottom)
    }
}

extension IconPickerView{
    var IconGrid: some View{
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
    }
}
extension IconPickerView{
    var EmptyIconView: some View{
        
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No icons found")
                .font(.openSansHeadline)
                .foregroundColor(.secondary)
            
            Text("Try searching with different keywords")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: .infinity)
        
    }
}
