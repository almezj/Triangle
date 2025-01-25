//
//  ExerciseSelectorView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 25.01.2025.
//

import SwiftUI

struct ExerciseSelectorView: View {
    @State private var selectedExercise: Int? = nil

    let exercises = [
        "Social Cues", "Focus & Attention", "Facial Expressions", "Roleplay Scenarios"
    ]

    var body: some View {
        ZStack{
            NavigationStack {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 20) {
                        ForEach(exercises.indices, id: \ .self) { index in
                            ExerciseCard(title: exercises[index], isLocked: index > 0) {
                                selectedExercise = index
                            }
                        }
                    }
                    .padding()
                }
                .background(ColorTheme.background)
                .toolbarBackground(.hidden, for: .navigationBar)
            }
        }
    }
}


struct ExerciseSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSelectorView()
            .previewDevice("iPad Pro 11-inch")
    }
}
