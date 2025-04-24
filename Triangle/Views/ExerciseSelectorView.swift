//
//  ContentView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 02.01.2025.
//

import SwiftUI

struct ExerciseParameters: Identifiable, Hashable {
    let id: Int
    let totalTriangles: Int
    let currentLevelIndex: Int
}

struct ExerciseSelectorView: View {
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    @EnvironmentObject var dashboardController: DashboardController
    @Environment(\.dismiss) var dismiss

    private let exercises: [(id: Int, totalLevels: Int)] = [
        (1, 8), (2, 8), (3, 8), (4, 8)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TopNavigationBar(title: "Exercises", onBack: { dismiss() })
                ScrollView {
                    VStack {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 10
                        ) {
                            ForEach(exercises, id: \.id) { exercise in
                                if exercise.id == 1 {
                                    let currentLevel = userDataStore.getCurrentLevel(exerciseId: exercise.id)
                                    if currentLevel > 6 {
                                        ExerciseCard(id: exercise.id, isLocked: false)
                                    } else {
                                        NavigationLink(destination: getExerciseForCurrentLevel(exerciseId: exercise.id)) {
                                            ExerciseCard(id: exercise.id, isLocked: false)
                                        }
                                    }
                                } else {
                                    ExerciseCard(id: exercise.id, isLocked: true)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .background(Color(hex: 0xB5CFE3))
        }
    }
    
    private func getExerciseForCurrentLevel(exerciseId: Int) -> some View {
        let currentLevel = userDataStore.getCurrentLevel(exerciseId: exerciseId)
        
        // If we've completed all levels, show a completion message and dismiss
        if currentLevel > 6 {
            return AnyView(
                VStack {
                    Text("Congratulations!")
                        .font(.largeTitle)
                        .padding()
                    Text("You've completed all levels!")
                        .font(.title2)
                        .padding()
                    Button("Back to Exercises") {
                        dismiss()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: 0xB5CFE3))
            )
        }
        
        let exercise: Exercise = {
            switch currentLevel {
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
                fatalError("No level found for ID \(currentLevel)")
            }
        }()
        
        return exercise.startExercise(onComplete: {
            print(">>> Exercise completed <<<")
            userDataStore.unlockNextLevel(forExerciseId: exerciseId, totalLevels: 10)
        })
    }
}

struct ExerciseSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        let userDataStore = UserDataStore(userId: "previewUser")
        userDataStore.userData = userDataStore.loadUserData(for: "previewUser")
        return ExerciseSelectorView()
            .environmentObject(NavbarVisibility())
            .environmentObject(userDataStore)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro 11-inch")
    }
}
