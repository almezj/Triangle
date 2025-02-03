import SwiftUI

struct BodyLanguageRecognitionView: View {
    @Environment(\.presentationMode) var presentationMode // ✅ Allows dismissing the view
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
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color(hex: 0x4C708A))
                    .padding(.bottom, 15)

                // ✅ Display choices horizontally (3 images)
                HStack(spacing: 30) { // 🔹 Increased spacing for better layout
                    ForEach(availableBodyLanguages, id: \.self) { bodyLanguage in
                        Button(action: {
                            selectedBodyLanguage = bodyLanguage
                            isCorrect = (bodyLanguage == targetBodyLanguage) // ✅ Check against correct body language

                            if isCorrect == true {
                                onComplete() // ✅ Unlocks next level when correct

                                // ✅ Delay for feedback, then navigate back
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    presentationMode.wrappedValue.dismiss() // ✅ Automatically return to Level Selector
                                }
                            } else {
                                // ✅ Reset after delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    selectedBodyLanguage = nil
                                    isCorrect = nil
                                }
                            }
                        }) {
                            Image(bodyLanguage.imageName) // ✅ Load correct image
                                .resizable()
                                .scaledToFit() // 🔹 Ensures full image is visible without zooming in
                                .frame(width: 220, height: 220) // 🔹 Image size
                                .clipShape(RoundedRectangle(cornerRadius: 15)) // 🔹 Makes images rounded
                                .padding()
                                .background(
                                    selectedBodyLanguage == bodyLanguage
                                        ? (isCorrect == true ? Color(hex: 0x58D68D) : Color(hex: 0xEC7063)) // ✅ Muted colors
                                        : Color(hex: 0x96B6CF)
                                )
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                    }
                }
                .padding(.top, 30) // 🔹 Adjusted padding to balance the layout
            }
        }
    }
}
