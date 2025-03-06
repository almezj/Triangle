//
//  DashboardController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import SwiftUI

final class DashboardController: ObservableObject {
    @Published var selectedExerciseParameters: ExerciseParameters?
    @Published var progressData: ProgressData

    private let userId: String
    private let userDataManager = UserDataManager.shared

    init(userId: String) {
        self.userId = userId
        let userData = userDataManager.loadUserData(for: userId)
        self.progressData = userData.progress
    }

    /// Computes the progress fraction and current level for a given exercise.
    /// - Parameters:
    ///   - exerciseId: The unique ID for the exercise.
    ///   - totalLevels: The total number of levels in that exercise (e.g., 8).
    /// - Returns: A tuple (progress: fraction, currentLevel: Int)
    func getExerciseInfo(forExerciseId exerciseId: Int, totalLevels: Int) -> (
        progress: Double, currentLevel: Int
    ) {
        // Find the ExerciseProgress for this exercise
        guard
            let exerciseProgress = progressData.exerciseProgresses.first(
                where: { $0.exerciseId == exerciseId })
        else {
            // If none found, progress fraction = 0, currentLevel = 1
            return (0.0, 1)
        }
        // Count completed levels
        let completedCount = exerciseProgress.levels.filter { $0.completed }
            .count
        let fraction = Double(completedCount) / Double(totalLevels)
        let currentLevel = completedCount + 1  // e.g. if 3 are completed, user is on level 4
        return (fraction, currentLevel)
    }

    /// Called when a dashboard card is tapped to set up navigation.
    func selectExercise(id: Int, totalTriangles: Int, currentLevelIndex: Int) {
        let params = ExerciseParameters(
            id: id,
            totalTriangles: totalTriangles,
            currentLevelIndex: currentLevelIndex
        )
        self.selectedExerciseParameters = params
    }
}
