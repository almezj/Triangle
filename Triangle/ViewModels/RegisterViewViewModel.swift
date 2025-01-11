//
//  RegisterViewViewModel.swift
//  Triangle
//
//  Created by Josef Zemlicka on 18.01.2025.
//


import Foundation

class RegisterViewViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var navigateToDashboard: Bool = false
    
    
    // Empty constructor, idk what to do with it now but we might find some use for it later
    init() {}
    
    // Hardcoded register for now
    // TODO: Server validation + create new user
    func register() {
        self.isLoading = true
        self.errorMessage = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.errorMessage = "Can't register user at this time. Please try again later."
        }
    }
}
