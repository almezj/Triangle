//
//  ExerciseSelectorView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 25.01.2025.
//

import SwiftUI

// MARK: - LevelSelectorView
struct LevelSelectorView: View {
    let totalTriangles: Int
    @Binding var selectedLevelId: Int?
    @State private var hexagons: [Hexagon] = []
    @State private var currentLevelIndex: Int
    @State private var navigateToExercise = false
    @State private var selectedExerciseId: Int?

    init(
        totalTriangles: Int, currentLevelIndex: Int,
        selectedLevelId: Binding<Int?>
    ) {
        self.totalTriangles = totalTriangles
        self._currentLevelIndex = State(initialValue: currentLevelIndex)
        self._selectedLevelId = selectedLevelId
    }

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.3
            let requiredHeight = max(
                CGFloat(hexagons.count) * size * 2.4, geometry.size.height * 1.7
            )

            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ZStack {
                        ForEach(hexagons.indices, id: \.self) { hexIndex in
                            HexagonShape(
                                hexagon: hexagons[hexIndex],
                                hexIndex: hexIndex,
                                size: size,
                                offsetY: -CGFloat(hexIndex) * (size * 2.4),
                                currentLevelIndex: $currentLevelIndex,
                                onLevelSelect: { levelId in
                                    // ✅ Only allow selection if it's the blue current level
                                    if levelId == currentLevelIndex {
                                        selectedExerciseId = levelId
                                        navigateToExercise = true
                                    } else {
                                        print("❌ Cannot access level \(levelId). Only level \(currentLevelIndex) is playable.")
                                    }
                                },
                                isClockwise: hexIndex.isMultiple(of: 2)
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .rotationEffect(Angle(degrees: 180))
                    Spacer(minLength: requiredHeight)
                }
                .frame(maxWidth: .infinity, minHeight: requiredHeight)
            }
            .rotationEffect(Angle(degrees: 180))
            .onAppear {
                hexagons = HexagonView.createHexagons(
                    for: totalTriangles, currentLevelIndex: currentLevelIndex)
            }
        }
        .background(Color(ColorTheme.background))
        .ignoresSafeArea()
        .navigationDestination(isPresented: $navigateToExercise) {
            if let exerciseId = selectedExerciseId {
                let exercise: Exercise = {
                    switch exerciseId {
                    case 1:
                        return EmotionRecognitionExercise(predefinedEmotion: .happy)
                    case 2:
                        return EmotionRecognitionExercise(predefinedEmotion: .angry)
                    case 3:
                        return EmotionRecognitionExercise(predefinedEmotion: .crying)
                    case 4:
                        return BodyLanguageRecognitionExercise(targetBodyLanguage: .proud)
                    case 5:
                        return BodyLanguageRecognitionExercise(targetBodyLanguage: .angry)
                    case 6:
                        return BodyLanguageRecognitionExercise(targetBodyLanguage: .frustrated)
                    default:
                        fatalError("No exercise found for ID \(exerciseId)")
                    }
                }()

                exercise.startExercise(onComplete: {
                    // TODO: Save progress
                    
                    unlockNextLevel()
                })
            }
        }
    }

    // ✅ Unlocks the next level ONLY if the current level is completed
    func unlockNextLevel() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if currentLevelIndex < totalTriangles {
                print("✅ Unlocking Level \(currentLevelIndex + 1)")
                currentLevelIndex += 1
            } else {
                print("✅ All levels completed!")
            }
        }
    }
}

struct PreviewView: View {
    var body: some View {
        HexagonView(exerciseId: 1, currentLevelIndex: 3)  // Example dynamic values
    }
}

struct LevelSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro 11-inch")
    }
}
