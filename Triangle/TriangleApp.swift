//
//  TriangleApp.swift
//  Triangle
//
//  Created by Josef Zemlicka on 02.01.2025.
//

import SwiftUI

@main
struct TriangleApp: App {
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro 11-inch")
    }
}
