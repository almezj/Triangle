//
//  ContentView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 22.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .dashboard

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Group {
                    switch selectedTab {
                    case .leaderboard:
                        LeaderboardView()
                    case .dashboard:
                        DashboardView()
                    case .profile:
                        ProfileView()
                    }
                }
                .ignoresSafeArea(edges: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Navbar(selectedTab: $selectedTab)
                .frame(height: 100)
                .padding(.bottom, 10)
        }
        .background(ColorTheme.background)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
