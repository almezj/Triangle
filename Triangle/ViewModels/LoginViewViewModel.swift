//
//  LoginViewViewModel.swift
//  Triangle
//
//  Created by Josef Zemlicka on 18.01.2025.
//

import Foundation

class LoginViewViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var navigateToDashboard = false
    
    
    // Empty constructor, idk what to do with it now but we might find some use for it later
    init() {}
    
    // Hardcoded login for now
    // TODO: Server validation
    // TODO: Navigate to dashboard after succesfull login
    func login() {
        self.isLoading = true
        self.errorMessage = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            if self.username == "user" && self.password == "password" {
                self.navigateToDashboard = true
            } else {
                self.errorMessage = "Invalid username or password"
            }
        }
    }
}
