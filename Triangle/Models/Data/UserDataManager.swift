//
//  UserDataManager.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import Foundation

final class UserDataManager {
    static let shared = UserDataManager()  // Singletooooooon

    private init() {}

    /// Loads the user data for a given user identifier (e.g. username).
    /// - Parameter userId: The unique identifier for the user.
    /// - Returns: A UserData instance containing settings, progress, and customization data.
    func loadUserData(for userId: String) -> UserData {
        let key = userId
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let userData = try? decoder.decode(UserData.self, from: data) {
                return userData
            }
        }
        // Return default if no data
        let defaultSettings = SettingsData(
            musicVolume: 0.5, sfxVolume: 0.5, textSize: 1.0,
            selectedLanguage: "English")
        let defaultProgress = ProgressData(
            currentLevel: 1, completedExercises: [])
        let defaultCustomization = CustomizationData(
            currency: 0, unlockedCosmetics: [])
        return UserData(
            settings: defaultSettings, progress: defaultProgress,
            customization: defaultCustomization)
    }

    /// Saves the user data for a given user identifier.
    /// - Parameters:
    ///   - userData: The UserData instance to save.
    ///   - userId: The unique identifier for the user.
    func saveUserData(_ userData: UserData, for userId: String) {
        let key = userId
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(userData) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
