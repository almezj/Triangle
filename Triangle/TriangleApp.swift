//
//  TriangleApp.swift
//  Triangle
//
//  Created by Josef Zemlicka on 02.01.2025.
//

import SwiftUI

@main
struct TriangleApp: App {
    @StateObject var authManager = AuthenticationManager()

    init() {
        print(
            "UserDefaults at startup: \(UserDefaults.standard.dictionaryRepresentation())"
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authManager)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        if authManager.currentUserId != nil {
            ContentView()
        } else {
            OnboardingView()
        }
    }
}

struct TriangleApp_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(AuthenticationManager())
    }
}
