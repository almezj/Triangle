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
    @State private var selectedExerciseParameters: ExerciseParameters? = nil
    @State private var navigateToLevelSelector: Bool = false
    @State private var exerciseForNavigation: ExerciseParameters? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Grid(horizontalSpacing: 40, verticalSpacing: 40) {
                        GridRow {
                            DashboardCard(
                                title: "Getting Started",
                                imageNames: ["SocialTriangle"],
                                progress: 0.3,
                                currentExercise: 3,
                                locked: false,
                                action: {
                                    let params = ExerciseParameters(
                                        id: 1, totalTriangles: 8,
                                        currentLevelIndex: 3)
                                    selectedExerciseParameters = params
                                })
                            DashboardCard(
                                title: "A Day in the Park",
                                imageNames: ["SocialTriangle"],
                                progress: 0.1, currentExercise: 2,
                                locked: true,
                                action: {
                                    let params = ExerciseParameters(
                                        id: 2, totalTriangles: 8,
                                        currentLevelIndex: 2)
                                    selectedExerciseParameters = params
                                })
                        }
                        GridRow {
                            DashboardCard(
                                title: "School Sports Day",
                                imageNames: ["SocialTriangle"],
                                progress: 0, currentExercise: 1,
                                locked: true,
                                action: {
                                    let params = ExerciseParameters(
                                        id: 3, totalTriangles: 8,
                                        currentLevelIndex: 1)
                                    selectedExerciseParameters = params
                                })
                            DashboardCard(
                                title: "Coming soon...",
                                imageNames: ["SocialTriangle"],
                                progress: 0, currentExercise: 1,
                                locked: true,
                                action: {
                                    let params = ExerciseParameters(
                                        id: 4, totalTriangles: 8,
                                        currentLevelIndex: 1)
                                    selectedExerciseParameters = params
                                })
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
            .fullScreenCover(item: $selectedExerciseParameters) { params in
                LevelTransitionView(
                    totalTriangles: params.totalTriangles,
                    currentLevelIndex: params.currentLevelIndex,
                    exerciseId: params.id,
                    onCompletion: {
                        exerciseForNavigation = params
                        selectedExerciseParameters = nil
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
}

struct DetailView: View {
    let title: String

    var body: some View {
        VStack {
            Text("You are in the " + title + " view!")
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(NavbarVisibility())
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro 11-inch")
    }
}
