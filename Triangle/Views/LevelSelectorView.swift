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

    @StateObject var controller: LevelSelectorController

    @Environment(\.dismiss) private var dismiss

    init(
        totalTriangles: Int, currentLevelIndex: Int,
        selectedLevelId: Binding<Int?>
    ) {
        self.totalTriangles = totalTriangles
        self._selectedLevelId = selectedLevelId

        _controller = StateObject(
            wrappedValue: LevelSelectorController(
                totalTriangles: totalTriangles,
                currentLevelIndex: currentLevelIndex))
    }

    var body: some View {
        VStack(spacing: 0) {
            TopNavigationBar(
                title: "Level Selector",
                onBack: {
                    dismiss()
                })

            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height) * 0.3
                let requiredHeight = max(
                    CGFloat(controller.hexagons.count) * size * 2.4,
                    geometry.size.height * 1.7
                )

                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ZStack {
                            ForEach(controller.hexagons.indices, id: \.self) {
                                hexIndex in
                                HexagonShape(
                                    hexagon: controller.hexagons[hexIndex],
                                    hexIndex: hexIndex,
                                    size: size,
                                    offsetY: -CGFloat(hexIndex) * (size * 2.4),
                                    currentLevelIndex: $controller
                                        .currentLevelIndex,
                                    onLevelSelect: { levelId in
                                        controller.selectLevel(levelId: levelId)
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
            }
            .background(Color(ColorTheme.background))
            .ignoresSafeArea()
            .navigationDestination(isPresented: $controller.navigateToExercise)
            {
                if let exerciseId = controller.selectedExerciseId {
                    let exercise: Exercise = {
                        switch exerciseId {
                        case 1:
                            return EmotionRecognitionExercise(
                                predefinedEmotion: .happy)
                        case 2:
                            return EmotionRecognitionExercise(
                                predefinedEmotion: .angry)
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
                    exercise.startExercise {
                        controller.unlockNextLevel()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
        .navigationBarHidden(true)
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
