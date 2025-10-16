//
//  SignupView.swift
//  HabitTracker
//
//  Created by Shameem on 15/10/25.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 32) {
                        // Header Section
                        HeaderSection
                        
                        // Signup Form
                        SignupForm
                        
                        // Login Prompt
                        LoginPrompt
                    }
                    .frame(minHeight: geometry.size.height)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert("Error", isPresented: $authViewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authViewModel.errorMessage ?? "An unknown error occurred")
                .font(.openSansBody)
        }
        .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                dismiss()
            }
        }
    }
}

// MARK: - Header Section
extension SignupView {
    var HeaderSection: some View {
        VStack(spacing: 16) {
            // App Logo/Icon
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.green, .blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "person.badge.plus")
                    .font(.openSansCustomBold(size: 32))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("Create Account")
                    .font(.openSansLargeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Join us and start building better habits today")
                    .font(.openSansSubheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: - Signup Form
extension SignupView {
    var SignupForm: some View {
        VStack(spacing: 20) {
            // Name Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Full Name")
                    .font(.openSansHeadline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "person")
                        .font(.openSansBody)
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    
                    TextField("Enter your full name", text: $authViewModel.signupName)
                        .font(.openSansBody)
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
            
            // Email Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.openSansHeadline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "envelope")
                        .font(.openSansBody)
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    
                    TextField("Enter your email", text: $authViewModel.signupEmail)
                        .font(.openSansBody)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
            
            // Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.openSansHeadline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "lock")
                        .font(.openSansBody)
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    
                    if showPassword {
                        TextField("Enter your password", text: $authViewModel.signupPassword)
                            .font(.openSansBody)
                            .textFieldStyle(PlainTextFieldStyle())
                    } else {
                        SecureField("Enter your password", text: $authViewModel.signupPassword)
                            .font(.openSansBody)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .font(.openSansBody)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                
                // Password Requirements
                VStack(alignment: .leading, spacing: 4) {
                    PasswordRequirement(
                        text: "At least 6 characters",
                        isValid: authViewModel.signupPassword.count >= 6
                    )
                }
                .padding(.top, 4)
            }
            
            // Confirm Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Confirm Password")
                    .font(.openSansHeadline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "lock.fill")
                        .font(.openSansBody)
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    
                    if showConfirmPassword {
                        TextField("Confirm your password", text: $authViewModel.signupConfirmPassword)
                            .font(.openSansBody)
                            .textFieldStyle(PlainTextFieldStyle())
                    } else {
                        SecureField("Confirm your password", text: $authViewModel.signupConfirmPassword)
                            .font(.openSansBody)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    Button(action: {
                        showConfirmPassword.toggle()
                    }) {
                        Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                            .font(.openSansBody)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                
                // Password Match Indicator
                if !authViewModel.signupConfirmPassword.isEmpty {
                    PasswordRequirement(
                        text: "Passwords match",
                        isValid: authViewModel.signupPassword == authViewModel.signupConfirmPassword
                    )
                    .padding(.top, 4)
                }
            }
            
            // Terms and Privacy
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "info.circle")
                    .font(.openSansCaption)
                    .foregroundColor(.blue)
                    .padding(.top, 2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("By creating an account, you agree to our")
                        .font(.openSansCaption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Button("Terms of Service") {
                            // TODO: Show terms
                        }
                        .font(.openSansCaption)
                        .foregroundColor(.blue)
                        
                        Text("and")
                            .font(.openSansCaption)
                            .foregroundColor(.secondary)
                        
                        Button("Privacy Policy") {
                            // TODO: Show privacy policy
                        }
                        .font(.openSansCaption)
                        .foregroundColor(.blue)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 4)
            
            // Sign Up Button
            Button(action: {
                Task {
                    await authViewModel.signup()
                }
            }) {
                ZStack {
                    if authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Create Account")
                            .font(.openSansHeadline)
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.green, .blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .disabled(authViewModel.isLoading)
            .scaleEffect(authViewModel.isLoading ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: authViewModel.isLoading)
        }
    }
}

// MARK: - Login Prompt
extension SignupView {
    var LoginPrompt: some View {
        VStack(spacing: 16) {
            // Divider
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.secondary.opacity(0.3))
                
                Text("or")
                    .font(.openSansCaption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.secondary.opacity(0.3))
            }
            
            // Login Button
            Button(action: {
                dismiss()
            }) {
                HStack {
                    Text("Already have an account?")
                        .font(.openSansBody)
                        .foregroundColor(.primary)
                    
                    Text("Sign In")
                        .font(.openSansBody)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

// MARK: - Password Requirement Component
struct PasswordRequirement: View {
    let text: String
    let isValid: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isValid ? "checkmark.circle.fill" : "circle")
                .font(.openSansCaption)
                .foregroundColor(isValid ? .green : .secondary)
            
            Text(text)
                .font(.openSansCaption)
                .foregroundColor(isValid ? .green : .secondary)
        }
    }
}
