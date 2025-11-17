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
    @State private var showingForgotPassword = false
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
            .sheet(isPresented: $showingForgotPassword) {
                ForgotPasswordView()
                    .environmentObject(authViewModel)
            }
        }
        .alert("Error", isPresented: $authViewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(authViewModel.errorMessage ?? "An unknown error occurred")
                .font(.poppinsBody)
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
                    .font(.poppinsBold)
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("Welcome Back")
                    .font(.poppinsLargeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Sign in to continue tracking your habits")
                    .font(.poppinsSubheadline)
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
                    .font(.poppinsHeadline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "envelope")
                        .font(.poppinsBody)
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    
                    TextField("Enter your email", text: $authViewModel.loginEmail)
                        .font(.poppinsBody)
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
                    .font(.poppinsHeadline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "lock")
                        .font(.poppinsBody)
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    
                    if showPassword {
                        TextField("Enter your password", text: $authViewModel.loginPassword)
                            .font(.poppinsBody)
                            .textFieldStyle(PlainTextFieldStyle())
                    } else {
                        SecureField("Enter your password", text: $authViewModel.loginPassword)
                            .font(.poppinsBody)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .font(.poppinsBody)
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
                    showingForgotPassword = true
                }
                .font(.poppinsBody)
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
                            .font(.poppinsHeadline)
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
                    .font(.poppinsCaption)
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
                        .font(.poppinsBody)
                        .foregroundColor(.primary)
                    
                    Text("Sign Up")
                        .font(.poppinsBody)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
