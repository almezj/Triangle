//
//  DashboardController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import Foundation
import SwiftUI

final class DashboardController: ObservableObject {
    @Published var selectedExerciseParameters: ExerciseParameters?
    
    /// Call this method when a dashboard card is tapped.
    /// - Parameters:
    ///   - id: The unique ID for the exercise.
    ///   - totalTriangles: The total number of triangles (levels) associated with the exercise.
    ///   - currentLevelIndex: The current level index to be used for navigation.
    func selectExercise(id: Int, totalTriangles: Int, currentLevelIndex: Int) {
        let params = ExerciseParameters(id: id, totalTriangles: totalTriangles, currentLevelIndex: currentLevelIndex)
        self.selectedExerciseParameters = params
    }
}
