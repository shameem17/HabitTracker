//
//  ProfileView.swift
//  HabitTracker
//
//  Created by Shameem on 15/10/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingLogoutAlert = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            Text("User Profile")
                .font(.poppinsTitle)
                .fontWeight(.bold)
                .padding(.horizontal, 20)
                .padding(.top, 30)
            
            
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.purple)
                    .frame(width: 30)
                
                Text("Profile")
                    .font(.poppinsHeadline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                if let user = authViewModel.currentUser {
                    SettingsRow(
                        icon: "person.fill",
                        title: "Name",
                        value: user.profile?.name ?? "User",
                        showChevron: false
                    )
                    
                    SettingsRow(
                        icon: "envelope.fill",
                        title: "Email",
                        value: user.profile?.email ?? "n/a",
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
                            .font(.poppinsBody)
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
            Spacer()
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
                .font(.poppinsBody)
        }
    }
}
