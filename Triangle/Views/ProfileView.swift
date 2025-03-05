//
//  ProfileView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 22.01.2025.
//

import SwiftUI

// TODO: Come up with a better layout for the profile view and settle on what we want to show on this screen
// TODO: Add animated character


struct ProfileView: View {
    @State private var progress: Double = 0.75 // Example progress value
    @State private var activities: [String] = [
        "Completed 'Social Cues' exercise",
        "Unlocked 'Party Hat' cosmetic",
        "Achieved Level 5 in Focus Training"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    VStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 150, height: 150)
                            .cornerRadius(75)
                            .overlay(Text("Animated Character Here").font(.bodyText).foregroundColor(.gray))
                    }
                    .frame(maxWidth: .infinity)

                    Divider()

                    // Progress Overview
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Progress")
                            .font(.pageTitle)

                        ProgressView(value: progress) {
                            Text("Progress: \(Int(progress * 100))%")
                                .font(.bodyText)
                        }
                        .progressViewStyle(LinearProgressViewStyle(tint: ColorTheme.primary))

                        HStack {
                            Text("Milestones Achieved:")
                                .font(.bodyText)
                            Spacer()
                            Text("3/5") // Example milestone data
                                .font(.bodyText)
                                .foregroundColor(ColorTheme.primary)
                        }
                    }

                    Divider()

                    // Activity Feed
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent Activities")
                            .font(.pageTitle)

                        ForEach(activities, id: \ .self) { activity in
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
            .previewDevice("iPad Pro 11-inch")
    }
}

