//
//  AuthViewModel.swift
//  HabitTracker
//
//  Created by Shameem on 15/10/25.
//

import Foundation
import SwiftUI

// MARK: - Authentication View Model
@MainActor
class AuthViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    // MARK: - Login Form Properties
    @Published var loginEmail = ""
    @Published var loginPassword = ""
    
    // MARK: - Signup Form Properties
    @Published var signupName = ""
    @Published var signupEmail = ""
    @Published var signupPassword = ""
    @Published var signupConfirmPassword = ""
    
    // MARK: - Private Properties
    private let authService: AuthServiceProtocol
    private let authStorage = AuthStorage.shared
    
    // MARK: - Initialization
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        checkAuthenticationStatus()
    }
    
    // MARK: - Authentication Methods
    func login() async {
        guard validateLoginForm() else { return }
        
        isLoading = true
        errorMessage = nil
        let request = LoginRequest(email: loginEmail, password: loginPassword)
        authService.login(data: request) { result in
            DispatchQueue.main.async{
                self.isLoading = false
            }
            switch result{
            case .success(let authResult):
                self.handleAuthInfo(authResult: authResult)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
        
       
    }
    
    func signup() async {
        guard validateSignupForm() else { return }
        
        isLoading = true
        errorMessage = nil
        
        
        let request = SignupRequest(
            name: signupName,
            email: signupEmail,
            password: signupPassword,
            confirmPassword: signupConfirmPassword
        )
        authService.signup(data: request) { result in
            DispatchQueue.main.async{
                self.isLoading = false
            }
            switch result{
            case .success(let authResult):
                self.handleAuthInfo(authResult: authResult)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
        
    }
    
    func logout() async {
        isLoading = true
        
        do {
            _ = try await authService.logout()
            authStorage.clearAuthData()
            currentUser = nil
            isAuthenticated = false
        } catch {
            showError("Error logging out. Please try again.")
        }
        
        isLoading = false
    }
    
    // MARK: - Validation Methods
    private func validateLoginForm() -> Bool {
        if loginEmail.isEmpty {
            showError("Please enter your email")
            return false
        }
        
        if !isValidEmail(loginEmail) {
            showError("Please enter a valid email address")
            return false
        }
        
        if loginPassword.isEmpty {
            showError("Please enter your password")
            return false
        }
        
        if loginPassword.count < 6 {
            showError("Password must be at least 6 characters")
            return false
        }
        
        return true
    }
    
    private func validateSignupForm() -> Bool {
        if signupName.isEmpty {
            showError("Please enter your name")
            return false
        }
        
        if signupEmail.isEmpty {
            showError("Please enter your email")
            return false
        }
        
        if !isValidEmail(signupEmail) {
            showError("Please enter a valid email address")
            return false
        }
        
        if signupPassword.isEmpty {
            showError("Please enter a password")
            return false
        }
        
        if signupPassword.count < 6 {
            showError("Password must be at least 6 characters")
            return false
        }
        
        if signupConfirmPassword.isEmpty {
            showError("Please confirm your password")
            return false
        }
        
        if signupPassword != signupConfirmPassword {
            showError("Passwords do not match")
            return false
        }
        
        return true
    }
    
    // MARK: - Helper Methods
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    private func clearLoginForm() {
        loginEmail = ""
        loginPassword = ""
    }
    
    private func clearSignupForm() {
        signupName = ""
        signupEmail = ""
        signupPassword = ""
        signupConfirmPassword = ""
    }
    
    private func checkAuthenticationStatus() {
        currentUser = authStorage.getCurrentUser()
        isAuthenticated = authStorage.isAuthenticated
    }
}

extension AuthViewModel{
    func handleAuthInfo(authResult: AuthResponse){
        authStorage.saveAuthData(response: authResult)
        DispatchQueue.main.async{[weak self] in
            self?.isAuthenticated = true
        }
    }
}
