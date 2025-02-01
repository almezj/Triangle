//
//  LevelTransitionView.swift
//  Triangle
//
//  Created by Dillon Reilly on 31/01/2025.
//

import SwiftUI
import RiveRuntime

struct LevelTransitionView: View {
    @State private var navigateToLevelSelector = false
    @State private var riveViewModel = RiveViewModel(fileName: "ch_t") // ✅ Load mascot animation
    
    // ✅ Provide realistic values for navigation
    let totalTriangles: Int
    let currentLevelIndex: Int
    @State private var selectedLevelId: Int? = nil // Needs to be a @State variable

    var body: some View {
        ZStack {
            Color(hex: 0xB5CFE3)
                .edgesIgnoringSafeArea(.all)

            VStack {
                riveViewModel.view()
                    .frame(width: 300, height: 300)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: 0x4C708A)))
                    .scaleEffect(2)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                navigateToLevelSelector = true
            }
        }
        .navigationDestination(isPresented: $navigateToLevelSelector) {
            LevelSelectorView(
                totalTriangles: totalTriangles,
                currentLevelIndex: currentLevelIndex,
                selectedLevelId: $selectedLevelId // ✅ Pass Binding<Int?>
            )
        }
    }
}
