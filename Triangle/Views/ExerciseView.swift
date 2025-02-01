//
//  ExerciseView.swift
//  Triangle
//
//  Created by Dillon Reilly on 01/02/2025.
//

import SwiftUI

struct ExerciseView: View {
    let exerciseId: Int
    let onComplete: () -> Void // Callback to unlock the next level

    var body: some View {
        VStack {
            Text("Exercise \(exerciseId)")
                .font(.largeTitle)
                .padding()

            Spacer()

            Button("Complete Exercise") {
                onComplete()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .navigationTitle("Exercise \(exerciseId)")
    }
}
