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
    @Published var navigateToDashboard: Bool = false

    func login() {
        self.isLoading = true
        self.errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            if self.username == "user" && self.password == "password" {
                DispatchQueue.main.async {
                    self.navigateToDashboard = true
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid username or password"
                }
            }
        }
    }
}
