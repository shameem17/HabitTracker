//
//  LoginView.swift
//  HabitTracker
//
//  Created by Shameem on 15/10/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingSignup = false
    @State private var showPassword = false
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 32) {
                        // Header Section
                        HeaderSection
                        
                        // Login Form
                        LoginForm
                        
                        // Sign Up Option
                        SignUpPrompt
                    }
                    .frame(minHeight: geometry.size.height)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 40)
                }
            }
            .navigationDestination(for: String.self, destination: { _ in
                SignupView()
            })
        }
       
       
//        .sheet(isPresented: $showingSignup) {
//            SignupView()
//        }
        .alert("Error", isPresented: $authViewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authViewModel.errorMessage ?? "An unknown error occurred")
                .font(.openSansBody)
        }
    }
}

// MARK: - Header Section
extension LoginView {
    var HeaderSection: some View {
        VStack(spacing: 16) {
            // App Logo/Icon
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "target")
                    .font(.openSansCustomBold(size: 32))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("Welcome Back")
                    .font(.openSansLargeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Sign in to continue tracking your habits")
                    .font(.openSansSubheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: - Login Form
extension LoginView {
    var LoginForm: some View {
        VStack(spacing: 20) {
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
                    
                    TextField("Enter your email", text: $authViewModel.loginEmail)
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
                        TextField("Enter your password", text: $authViewModel.loginPassword)
                            .font(.openSansBody)
                            .textFieldStyle(PlainTextFieldStyle())
                    } else {
                        SecureField("Enter your password", text: $authViewModel.loginPassword)
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
            }
            
            // Forgot Password
            HStack {
                Spacer()
                Button("Forgot Password?") {
                    // TODO: Implement forgot password
                }
                .font(.openSansBody)
                .foregroundColor(.blue)
            }
            
            // Login Button
            Button(action: {
                Task {
                    await authViewModel.login()
                }
            }) {
                ZStack {
                    if authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Sign In")
                            .font(.openSansHeadline)
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .disabled(authViewModel.isLoading)
            .scaleEffect(authViewModel.isLoading ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: authViewModel.isLoading)
        }
    }
}

// MARK: - Sign Up Prompt
extension LoginView {
    var SignUpPrompt: some View {
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
            
            // Sign Up Button
            Button(action: {
                showingSignup = true
                path.append("SignupView")
            }) {
                HStack {
                    Text("Don't have an account?")
                        .font(.openSansBody)
                        .foregroundColor(.primary)
                    
                    Text("Sign Up")
                        .font(.openSansBody)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
