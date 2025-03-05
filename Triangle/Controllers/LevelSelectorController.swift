//
//  LevelSelectorController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import SwiftUI

final class LevelSelectorController: ObservableObject {
    @Published var hexagons: [Hexagon] = []
    @Published var currentLevelIndex: Int
    @Published var selectedExerciseId: Int? = nil
    @Published var navigateToExercise: Bool = false

    let totalTriangles: Int

    init(totalTriangles: Int, currentLevelIndex: Int) {
        self.totalTriangles = totalTriangles
        self.currentLevelIndex = currentLevelIndex
        self.hexagons = LevelSelectorController.createHexagons(for: totalTriangles, currentLevelIndex: currentLevelIndex)
    }
    
    static func createHexagons(for count: Int, currentLevelIndex: Int) -> [Hexagon] {
        let neededHexagons = count / 4
        let remainingTriangles = count % 4
        
        var newHexagons: [Hexagon] = []
        for _ in 0..<neededHexagons {
            newHexagons.append(Hexagon(visibleCount: 4))
        }
        if remainingTriangles > 0 {
            newHexagons.append(Hexagon(visibleCount: remainingTriangles))
        }
        return newHexagons
    }
    
    /// Called when a level button is tapped.
    func selectLevel(levelId: Int) {
        if levelId == currentLevelIndex {
            selectedExerciseId = levelId
            navigateToExercise = true
        } else {
            // TODO: Notify user that the level is locked... maybe a shake animation??
            print("Level \(levelId) is locked or already completed.")
        }
    }
    
    /// Unlocks the next level if available.
    func unlockNextLevel() {
        if currentLevelIndex < totalTriangles {
            currentLevelIndex += 1
            hexagons = LevelSelectorController.createHexagons(for: totalTriangles, currentLevelIndex: currentLevelIndex)
        } else {
            print("All levels completed!")
        }
    }
}




