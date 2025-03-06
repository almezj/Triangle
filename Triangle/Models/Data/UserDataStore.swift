//
//  UserDataStore.swift
//  Triangle
//
//  Created by Josef Zemlicka on 06.03.2025.
//

import SwiftUI

final class UserDataStore: ObservableObject {
    @Published var userData: UserData
    private let userId: String

    init(userId: String) {
        self.userId = userId
        self.userData = UserDataManager.shared.loadUserData(for: userId)
    }

    /// Updates the settings and saves the data.
    func updateSettings(_ newSettings: SettingsData) {
        userData.settings = newSettings
        save()
    }

    /// Updates the progress and saves the data.
    func updateProgress(_ newProgress: ProgressData) {
        userData.progress = newProgress
        save()
    }

    /// Updates the customization data and saves the data.
    func updateCustomization(_ newCustomization: CustomizationData) {
        userData.customization = newCustomization
        save()
    }
    
    func levelCompleted(forExerciseId exerciseId: Int, levelId: Int) {
        // Load userData from memory
        var newProgress = userData.progress

        // Locate or create the exercise
        if let index = newProgress.exerciseProgresses.firstIndex(where: { $0.exerciseId == exerciseId }) {
            // Mark the level as completed
            if let levelIndex = newProgress.exerciseProgresses[index].levels.firstIndex(where: { $0.levelId == levelId }) {
                newProgress.exerciseProgresses[index].levels[levelIndex].completed = true
            } else {
                // If the level doesn’t exist, append a new record
                newProgress.exerciseProgresses[index].levels.append(Level(levelId: levelId, completed: true, currency: 0, experience: 0))
            }
        } else {
            // If no exercise record exists, create one
            let newExercise = ExerciseProgress(exerciseId: exerciseId, currentLevelId: levelId + 1 , levels: [Level(levelId: levelId, completed: true, currency: 0, experience: 0)])
            newProgress.exerciseProgresses.append(newExercise)
        }

        // Save it back
        userData.progress = newProgress
        save()
    }

    /// Saves the current userData to persistent storage.
    private func save() {
        UserDataManager.shared.saveUserData(userData, for: userId)
        print("UserData saved for user \(userId)")
    }
}
