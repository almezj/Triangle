//
//  LevelTransitionView.swift
//  Triangle
//
//  Created by Dillon Reilly on 31/01/2025.
//

import SwiftUI
import RiveRuntime

struct LevelTransitionView: View {
    @State private var navigateToLogin = false

    var body: some View {
        ZStack {
            Color(hex: 0xB5CFE3)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Loading...")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: 0x4C708A))
                    .transition(.opacity)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: 0x4C708A)))
                    .scaleEffect(2)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                navigateToLogin = true
            }
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            OnboardingView()  // ✅ Redirect to Login
        }
    }
}
