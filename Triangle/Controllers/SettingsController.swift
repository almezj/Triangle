//
//  SettingsController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import SwiftUI

final class SettingsController: ObservableObject {
    private let userId: String
    private let userDataManager = UserDataManager.shared

    @Published var userData: UserData {
        didSet {
            // Save the entire model on each change
            // Might optimize this later but this should be good for now
            userDataManager.saveUserData(userData, for: userId)
        }
    }

    // Provide the list of available languages.
    var languages: [String] {
        return ["English", "Czech", "Spanish"]
    }

    init(userId: String) {
        self.userId = userId
        self.userData = userDataManager.loadUserData(for: userId)
    }

    // MARK: - Updates

    func updateMusicVolume(_ volume: Double) {
        userData.settings.musicVolume = volume
    }

    func updateSFXVolume(_ volume: Double) {
        userData.settings.sfxVolume = volume
    }

    func updateTextSize(_ size: Double) {
        userData.settings.textSize = size
    }

    func updateLanguage(_ language: String) {
        userData.settings.selectedLanguage = language
    }

    // MARK: - Reset

    func resetProgress() {
        // Reset function for debugging but idk, we might keep this in.
        userData.progress = ProgressData(
            currentLevel: 1, completedExercises: [])
    }
}
