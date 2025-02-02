//
//  EmotionRecognitionExercise.swift
//  Triangle
//
//  Created by Dillon Reilly on 02/02/2025.
//

import SwiftUI

struct EmotionRecognitionExercise: Exercise {
    let id: Int = 1
    let title: String = "Emotion Recognition"
    let description: String = "Identify the emotion displayed by Tom the Triangle!"
    var isCompleted: Bool = false

    func startExercise(onComplete: @escaping () -> Void) -> AnyView {
        AnyView(EmotionRecognitionView(onComplete: onComplete))
    }
}
