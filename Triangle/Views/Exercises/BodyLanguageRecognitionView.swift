//
//  BodyLanguageRecognitionView.swift
//  Triangle
//
//  Created by Dillon Reilly on 03/02/2025.
//


import SwiftUI

struct BodyLanguageRecognitionView: View {
    let onComplete: () -> Void
    @State private var targetBodyLanguage: BodyLanguage
    @State private var selectedBodyLanguage: BodyLanguage? = nil
    @State private var isCorrect: Bool? = nil
    private let availableBodyLanguages: [BodyLanguage]

    init(targetBodyLanguage: BodyLanguage? = nil, onComplete: @escaping () -> Void) {
        let initialBodyLanguage = targetBodyLanguage ?? BodyLanguage.random()
        self.onComplete = onComplete
        self._targetBodyLanguage = State(initialValue: initialBodyLanguage)

        // ✅ Pick 2 incorrect random body language poses
        var otherBodyLanguages = BodyLanguage.allCases.filter { $0 != initialBodyLanguage }.shuffled()
        let incorrectOptions = Array(otherBodyLanguages.prefix(2))

        // ✅ Ensure the correct body language is included, then shuffle
        self.availableBodyLanguages = ([initialBodyLanguage] + incorrectOptions).shuffled()
    }

    var body: some View {
        ZStack {
            Color(hex: 0xB5CFE3)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Which body language matches '\(targetBodyLanguage.rawValue)'?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: 0x4C708A))
                    .padding(.bottom, 10)

                // ✅ Display choices horizontally (3 images)
                HStack(spacing: 20) {
                    ForEach(availableBodyLanguages, id: \.self) { bodyLanguage in
                        Button(action: {
                            selectedBodyLanguage = bodyLanguage
                            isCorrect = (bodyLanguage == targetBodyLanguage) // ✅ Check against correct body language

                            if isCorrect == true {
                                onComplete()
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    selectedBodyLanguage = nil
                                    isCorrect = nil
                                }
                            }
                        }) {
                            Image(bodyLanguage.imageName) // ✅ Load correct image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .padding()
                                .background(
                                    selectedBodyLanguage == bodyLanguage
                                        ? (isCorrect == true ? Color.green : Color.red) // ✅ Highlight selection
                                        : Color(hex: 0x96B6CF)
                                )
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
    }
}
