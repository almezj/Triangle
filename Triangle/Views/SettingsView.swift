//
//  SettingsView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 23.01.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settingsController = SettingsController(
        userId: "currentUserID")
    @State private var showPrivacyPolicy: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Account Section
                    Group {
                        Text("Account")
                            .font(.pageTitle)
                        Button("Update Email") {
                            print("Update Email button tapped")
                        }
                        .buttonStyle(TrianglePrimaryButton())

                        Button("Change Password") {
                            print("Change Password button tapped")
                        }
                        .buttonStyle(TrianglePrimaryButton())
                    }

                    Divider()

                    // Accessibility Section
                    Group {
                        Text("Accessibility")
                            .font(.pageTitle)
                        VStack(alignment: .leading) {
                            Text("Text Size")
                                .font(.bodyText)
                            Slider(
                                value: $settingsController.userData.settings
                                    .textSize,
                                in: 0.8...1.5,
                                step: 0.1,
                                label: { Text("Text Size") }
                            )
                        }
                    }

                    Divider()

                    // Sound Section
                    Group {
                        Text("Sound")
                            .font(.pageTitle)
                        VStack(alignment: .leading) {
                            Text("Music Volume")
                                .font(.bodyText)
                            Slider(
                                value: $settingsController.userData.settings
                                    .musicVolume,
                                in: 0...1,
                                step: 0.1,
                                label: { Text("Music Volume") }
                            )

                            Text("SFX Volume")
                                .font(.bodyText)
                            Slider(
                                value: $settingsController.userData.settings
                                    .sfxVolume,
                                in: 0...1,
                                step: 0.1,
                                label: { Text("SFX Volume") }
                            )
                        }
                    }

                    Divider()

                    // General Section
                    Group {
                        Text("General")
                            .font(.pageTitle)
                        VStack(alignment: .leading) {
                            Text("Language")
                                .font(.bodyText)
                            Picker(
                                "Language",
                                selection: $settingsController.userData.settings
                                    .selectedLanguage
                            ) {
                                ForEach(
                                    settingsController.languages, id: \.self
                                ) { language in
                                    Text(language)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())

                            Button("Reset Progress") {
                                settingsController.resetProgress()
                            }
                            .buttonStyle(TriangleSecondaryButton())
                        }
                    }

                    Divider()

                    // App Info Section
                    Group {
                        Text("App Info")
                            .font(.pageTitle)
                        VStack(alignment: .leading) {
                            Text("Version: 1.0.0")
                                .font(.bodyText)
                            Button("Privacy Policy") {
                                showPrivacyPolicy = true
                            }
                            .buttonStyle(TriangleSecondaryButton())
                            .sheet(isPresented: $showPrivacyPolicy) {
                                PrivacyPolicyView(
                                    isPresented: $showPrivacyPolicy)
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewDevice("iPad Pro 11-inch")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
