//
//  ProfileView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 22.01.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var profileController = ProfileController()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Animated Character Placeholder
                    VStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 150, height: 150)
                            .cornerRadius(75)
                            .overlay(
                                Text("Animated Character Here")
                                    .font(.bodyText)
                                    .foregroundColor(.gray)
                            )
                    }
                    .frame(maxWidth: .infinity)

                    Divider()

                    // Progress Overview
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Progress")
                            .font(.pageTitle)

                        ProgressView(value: profileController.progress) {
                            Text(
                                "Progress: \(Int(profileController.progress * 100))%"
                            )
                            .font(.bodyText)
                        }
                        .progressViewStyle(
                            LinearProgressViewStyle(tint: ColorTheme.primary))

                        HStack {
                            Text("Milestones Achieved:")
                                .font(.bodyText)
                            Spacer()
                            Text("3/5")  // Placeholder milestone data.
                                .font(.bodyText)
                                .foregroundColor(ColorTheme.primary)
                        }
                    }

                    Divider()

                    // Activity Feed
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent Activities")
                            .font(.pageTitle)

                        ForEach(profileController.activities, id: \.self) {
                            activity in
                            HStack {
                                Circle()
                                    .fill(ColorTheme.primary)
                                    .frame(width: 8, height: 8)

                                Text(activity)
                                    .font(.bodyText)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                }
                .padding()
            }
            .background(ColorTheme.background)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
