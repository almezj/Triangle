//
//  Navbar.swift
//  Triangle
//
//  Created by Josef Zemlicka on 22.01.2025.
//

import SwiftUI

struct Navbar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            VStack(spacing: 16) {
                HStack(spacing: -15) {
                    // Leaderboard Button
                    Button(action: { selectedTab = .leaderboard }) {
                        ZStack {
                            TriangleShape()
                                .fill(selectedTab == .leaderboard ? ColorTheme.accent : ColorTheme.text)
                                .frame(width: 80, height: 80)
                                .offset(y: 4)

                            TriangleShape()
                                .fill(selectedTab == .leaderboard ? ColorTheme.secondary : ColorTheme.primary)
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(0))

                            Image(systemName: Tab.leaderboard.icon)
                                .font(.system(size: 80 * 0.4))
                                .foregroundColor(selectedTab == .leaderboard ? ColorTheme.text : ColorTheme.background)
                                .shadow(radius: 2, x: 0, y: 4)
                                .offset(x: 0, y: 80 * 0.1)
                        }
                    }

                    // Dashboard Button
                    Button(action: { selectedTab = .dashboard }) {
                        ZStack {
                            TriangleShape()
                                .fill(selectedTab == .dashboard ? ColorTheme.accent : ColorTheme.text)
                                .frame(width: 100, height: 100)
                                .rotationEffect(.degrees(180))
                                .offset(y: 5)

                            TriangleShape()
                                .fill(selectedTab == .dashboard ? ColorTheme.secondary : ColorTheme.primary)
                                .frame(width: 100, height: 100)
                                .rotationEffect(.degrees(180))

                            Image(systemName: Tab.dashboard.icon)
                                .font(.system(size: 100 * 0.4))
                                .foregroundColor(selectedTab == .dashboard ? ColorTheme.text : ColorTheme.background)
                                .shadow(radius: 2, x: 0, y: 4)
                                .offset(x: 0, y: 100 * -0.1)
                        }
                    }
                    .offset(y: -15)

                    // Profile Button
                    Button(action: { selectedTab = .profile }) {
                        ZStack {
                            TriangleShape()
                                .fill(selectedTab == .profile ? ColorTheme.accent : ColorTheme.text)
                                .frame(width: 80, height: 80)
                                .offset(y: 4)

                            TriangleShape()
                                .fill(selectedTab == .profile ? ColorTheme.secondary : ColorTheme.primary)
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(0))

                            Image(systemName: Tab.profile.icon)
                                .font(.system(size: 80 * 0.4))
                                .foregroundColor(selectedTab == .profile ? ColorTheme.text : ColorTheme.background)
                                .shadow(radius: 2, x: 0, y: 4)
                                .offset(x: 0, y: 80 * 0.1)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Navbar(selectedTab: .constant(.profile))
}
