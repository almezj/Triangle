import SwiftUI
import CloudKit

class LoginViewViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isICloudAvailable: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var navigateToDashboard: Bool = false
    
    private let cloudKitManager = CloudKitManager.shared

    init() {
        checkiCloudAvailability()
    }

    func checkiCloudAvailability() {
        cloudKitManager.checkiCloudStatus { [weak self] available in
            DispatchQueue.main.async {
                self?.isICloudAvailable = available
            }
        }
    }

    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password cannot be empty."
            return
        }

        isLoading = true

        cloudKitManager.fetchUserForLogin(username: username, password: password) { success, record, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                } else if success {
                    self.errorMessage = nil
                    print("✅ Login successful - Navigating to Dashboard")
                    self.navigateToDashboard = true
                } else {
                    self.errorMessage = "Invalid username or password."
                }
            }
        }
    }

}
