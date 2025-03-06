//
//  Untitled.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import Foundation



struct Level: Codable {
    var levelId: Int
    var completed: Bool
    var currency: Int
    var experience: Int
}

struct ExerciseProgress: Codable {
    var exerciseId: Int
    var currentLevelId: Int
    var levels: [Level]
}

struct ProgressData: Codable {
    var exerciseProgresses: [ExerciseProgress]
    
    init(exerciseProgresses: [ExerciseProgress] = []) {
        self.exerciseProgresses = exerciseProgresses
    }
}

extension ProgressData: CustomStringConvertible {
    var description: String {
        "ProgressData with \(exerciseProgresses.count) exercises"
    }
}
