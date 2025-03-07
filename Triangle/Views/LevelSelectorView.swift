//
//  ExerciseSelectorView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 25.01.2025.
//

import SwiftUI

struct LevelSelectorView: View {
    @EnvironmentObject var userDataStore: UserDataStore
    let exerciseId: Int
    let totalTriangles: Int
    @Binding var selectedLevelId: Int?

    @State private var hexagons: [Hexagon] = []
    @State private var currentLevelIndex: Int
    @State private var selectedExerciseId: Int? = nil

    init(
        exerciseId: Int,
        totalTriangles: Int,
        currentLevelIndex: Int,
        selectedLevelId: Binding<Int?>
    ) {
        self.exerciseId = exerciseId
        self.totalTriangles = totalTriangles
        self._currentLevelIndex = State(initialValue: currentLevelIndex)
        self._selectedLevelId = selectedLevelId
    }

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.3
            let requiredHeight = max(
                CGFloat(hexagons.count) * size * 2.4,
                geometry.size.height * 1.7
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
                                    if levelId == currentLevelIndex {
                                        print(
                                            "Navigating to level \(levelId)...")
                                        selectedExerciseId = exerciseId
                                    } else {
                                        print(
                                            "❌ Cannot access level \(levelId). Only level \(currentLevelIndex) is playable."
                                        )
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
                print("Appeared, reloading hexagons...")
                hexagons = HexagonView.createHexagons(
                    for: totalTriangles,
                    currentLevelIndex: currentLevelIndex
                )
            }
        }
        .background(Color(ColorTheme.background))
        .ignoresSafeArea()
        .navigationDestination(item: $selectedExerciseId) { exerciseId in
            let exercise: Exercise = {
                print("Navigation to exercise \(exerciseId)")
                switch exerciseId {
                case 1:
                    return EmotionRecognitionExercise(predefinedEmotion: .happy)
                case 2:
                    return EmotionRecognitionExercise(predefinedEmotion: .angry)
                case 3:
                    return EmotionRecognitionExercise(
                        predefinedEmotion: .crying)
                case 4:
                    return BodyLanguageRecognitionExercise(
                        targetBodyLanguage: .proud)
                case 5:
                    return BodyLanguageRecognitionExercise(
                        targetBodyLanguage: .angry)
                case 6:
                    return BodyLanguageRecognitionExercise(
                        targetBodyLanguage: .frustrated)
                default:
                    fatalError("No exercise found for ID \(exerciseId)")
                }
            }()
            exercise.startExercise(onComplete: {
                print(">>> Exercise completed <<<")
                userDataStore.unlockNextLevel(
                    forExerciseId: exerciseId,
                    currentLevel: currentLevelIndex,
                    totalLevels: totalTriangles
                )
            })
            .onDisappear {
                selectedExerciseId = nil
            }
        }
    }
}

struct LevelSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a preview binding for selectedLevelId.
        LevelSelectorView(
            exerciseId: 1,
            totalTriangles: 6, currentLevelIndex: 3,
            selectedLevelId: .constant(nil)
        )
        .environmentObject(UserDataStore(userId: "previewUser"))
        .previewInterfaceOrientation(.landscapeLeft)
        .previewDevice("iPad Pro 11-inch")
    }
}
