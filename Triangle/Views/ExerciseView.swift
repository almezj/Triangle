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
    @State private var buttonDisabled = false  // ✅ Prevents multiple unlocks

    var body: some View {
        VStack {
            Text("Exercise \(exerciseId)")
                .font(.largeTitle)
                .padding()

            Spacer()

            Button(action: {
                if !buttonDisabled {
                    buttonDisabled = true  // ✅ Disable button after first tap
                    onComplete()
                }
            }) {
                Text("Complete Exercise")
                    .padding()
                    .background(buttonDisabled ? Color.gray : Color.green)  // ✅ Gray out when disabled
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(buttonDisabled) // ✅ Disable the button once clicked

            Spacer()
        }
        .navigationTitle("Exercise \(exerciseId)")
    }
}
