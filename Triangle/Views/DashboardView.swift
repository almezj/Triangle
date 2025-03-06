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

struct DashboardView: View {
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    @StateObject var dashboardController: DashboardController
    @State private var navigateToLevelSelector: Bool = false
    @State private var exerciseForNavigation: ExerciseParameters?

    // Inject a preconfigured DashboardController.
    init(userDataStore: UserDataStore) {
        _dashboardController = StateObject(
            wrappedValue: DashboardController(userDataStore: userDataStore))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Define your exercise definitions
                    let exercises: [(id: Int, totalLevels: Int)] = [
                        (1, 8), (2, 8), (3, 8), (4, 8),
                    ]

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()), GridItem(.flexible()),
                        ],
                        spacing: 40
                    ) {
                        ForEach(exercises, id: \.id) { exercise in
                            let info = dashboardController.getExerciseInfo(
                                forExerciseId: exercise.id,
                                totalLevels: exercise.totalLevels)
                            DashboardCard(
                                title: titleForExercise(
                                    exerciseId: exercise.id),
                                imageNames: imageNamesForExercise(
                                    exerciseId: exercise.id),
                                progress: info.progress,
                                currentExercise: info.currentLevel,
                                locked: isExerciseLocked(
                                    exerciseId: exercise.id,
                                    currentLevel: info.currentLevel),
                                action: {
                                    dashboardController.selectExercise(
                                        id: exercise.id,
                                        totalTriangles: exercise.totalLevels,
                                        currentLevelIndex: info.currentLevel)
                                }
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(20)
            }
            .onAppear {
                navbarVisibility.isVisible = true
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0xB5CFE3))
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(
                item: $dashboardController.selectedExerciseParameters
            ) { params in
                LevelTransitionView(
                    totalTriangles: params.totalTriangles,
                    currentLevelIndex: params.currentLevelIndex,
                    exerciseId: params.id,
                    onCompletion: {
                        dashboardController.selectedExerciseParameters = nil
                        exerciseForNavigation = params
                        navigateToLevelSelector = true
                    }
                )
                .environmentObject(navbarVisibility)
            }
            .navigationDestination(isPresented: $navigateToLevelSelector) {
                if let navParams = exerciseForNavigation {
                    LevelSelectorView(
                        totalTriangles: navParams.totalTriangles,
                        currentLevelIndex: navParams.currentLevelIndex,
                        selectedLevelId: .constant(nil)
                    )
                    .environmentObject(navbarVisibility)
                }
            }
        }
    }

    // MARK: - Helper Functions

    func titleForExercise(exerciseId: Int) -> String {
        switch exerciseId {
        case 1: return "Getting Started"
        case 2: return "A Day in the Park"
        case 3: return "School Sports Day"
        case 4: return "Coming soon..."
        default: return "Exercise \(exerciseId)"
        }
    }

    func imageNamesForExercise(exerciseId: Int) -> [String] {
        return ["SocialTriangle"]
    }

    func isExerciseLocked(exerciseId: Int, currentLevel: Int) -> Bool {
        if exerciseId == 1 { return false }
        return currentLevel == 1
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let userDataStore = UserDataStore(userId: "previewUser")
        userDataStore.userData = userDataStore.loadUserData(for: "previewUser")
        let dashboardController = DashboardController(
            userDataStore: userDataStore)

        return DashboardView(userDataStore: userDataStore)
            .environmentObject(NavbarVisibility())
            .environmentObject(userDataStore)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro 11-inch")
    }
}
