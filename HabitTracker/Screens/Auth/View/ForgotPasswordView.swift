//
//  ForgotPasswordView.swift
//  HabitTracker
//
//  Created by AI Assistant on 17/11/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var email = ""
    @State private var showSuccessMessage = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "envelope.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                            .padding(.top, 40)
                        
                        Text("Forgot Password?")
                            .font(.poppinsLargeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("No worries, we'll send you reset instructions")
                            .font(.poppinsBody)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    
                    if showSuccessMessage {
                        // Success Message
                        VStack(spacing: 20) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                            
                            Text("Check Your Email")
                                .font(.poppinsTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            VStack(spacing: 12) {
                                Text("We've sent password reset instructions to:")
                                    .font(.poppinsBody)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Text(email)
                                    .font(.poppinsHeadline)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 20)
                                
                                Text("Please check your inbox and follow the instructions in the email to reset your password.")
                                    .font(.poppinsBody)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 30)
                                    .padding(.top, 8)
                            }
                            .padding(.horizontal, 20)
                            
                            // Instructions Card
                            VStack(alignment: .leading, spacing: 16) {
                                Text("What to do next:")
                                    .font(.poppinsHeadline)
                                    .fontWeight(.semibold)
                                
                                InstructionRow(
                                    number: "1",
                                    text: "Open your email inbox"
                                )
                                
                                InstructionRow(
                                    number: "2",
                                    text: "Look for an email from Habit Tracker"
                                )
                                
                                InstructionRow(
                                    number: "3",
                                    text: "Click the reset password link"
                                )
                                
                                InstructionRow(
                                    number: "4",
                                    text: "Create a new password"
                                )
                                
                                InstructionRow(
                                    number: "5",
                                    text: "Return to the app and sign in"
                                )
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : Color(UIColor.systemGray6).opacity(0.5))
                            )
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            // Note
                            VStack(spacing: 8) {
                                Text("Didn't receive the email?")
                                    .font(.poppinsCaption)
                                    .foregroundColor(.secondary)
                                
                                Text("Check your spam folder or try again in a few minutes")
                                    .font(.poppinsCaption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 30)
                            .padding(.top, 10)
                        }
                        .padding(.vertical, 20)
                        
                    } else {
                        // Email Input Form
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email Address")
                                    .font(.poppinsHeadline)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    Image(systemName: "envelope")
                                        .foregroundColor(.gray)
                                    
                                    TextField("Enter your email", text: $email)
                                        .font(.poppinsBody)
                                        .textContentType(.emailAddress)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : Color(UIColor.systemGray6).opacity(0.5))
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            // Send Instructions Button
                            Button(action: {
                                sendResetInstructions()
                            }) {
                                HStack {
                                    if authViewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    } else {
                                        Text("Send Instructions")
                                            .font(.poppinsHeadline)
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    email.isEmpty ? Color.gray : Color.blue
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(email.isEmpty || authViewModel.isLoading)
                            .padding(.horizontal, 20)
                            
                            // Info Text
                            Text("Enter the email address associated with your account and we'll send you a link to reset your password.")
                                .font(.poppinsCaption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                                .padding(.top, 10)
                        }
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                    
                    // Back to Login Button
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 14))
                            Text("Back to Login")
                                .font(.poppinsHeadline)
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func sendResetInstructions() {
        // Here you would typically call your API to send reset email
        // For now, we'll just show the success message
        withAnimation {
            showSuccessMessage = true
        }
        
        // Simulate API call
        authViewModel.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            authViewModel.isLoading = false
        }
    }
}

// MARK: - Instruction Row Component
struct InstructionRow: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.poppinsHeadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Circle().fill(Color.blue))
            
            Text(text)
                .font(.poppinsBody)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthViewModel())
}
