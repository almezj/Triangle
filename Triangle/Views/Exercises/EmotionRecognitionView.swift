import SwiftUI
import RiveRuntime

struct EmotionRecognitionView: View {
    let onComplete: () -> Void
    @State private var targetEmotion: Emotion
    @State private var selectedEmotion: Emotion? = nil
    @State private var isCorrect: Bool? = nil
    @State private var riveViewModel: RiveViewModel
    private let availableEmotions: [Emotion]

    init(predefinedEmotion: Emotion? = nil, onComplete: @escaping () -> Void) {
        let initialEmotion = predefinedEmotion ?? Emotion.random()
        self.onComplete = onComplete
        self._targetEmotion = State(initialValue: initialEmotion)
        self._riveViewModel = State(initialValue: RiveViewModel(fileName: "ch_t", animationName: initialEmotion.animationName))

        // ✅ Pick 2 incorrect random emotions, ensuring no duplicates
        var otherEmotions = Emotion.allCases.filter { $0 != initialEmotion }.shuffled()
        let selectedIncorrect = Array(otherEmotions.prefix(2))

        // ✅ Ensure the correct emotion is included, then shuffle
        self.availableEmotions = ([initialEmotion] + selectedIncorrect).shuffled()
    }

    var body: some View {
        ZStack {
            Color(hex: 0xB5CFE3) // ✅ Background color from LevelTransitionView
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("What emotion is the mascot showing?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: 0x4C708A))
                    .padding(.bottom, 10)

                // 🎭 Display the Rive animation
                riveViewModel.view()
                    .frame(width: 320, height: 320) // ✅ Slightly larger for emphasis

                // ✅ Display choices horizontally
                HStack(spacing: 20) {
                    ForEach(availableEmotions, id: \.self) { emotion in
                        Button(action: {
                            selectedEmotion = emotion
                            isCorrect = (emotion == targetEmotion)

                            if isCorrect == true { // ✅ Unlock the next level when correct
                                onComplete()
                            }
                        }) {
                            Text(emotion.rawValue)
                                .font(.headline)
                                .frame(width: 120, height: 50) // ✅ Fixed size for consistency
                                .background(
                                    isCorrect == nil
                                        ? Color(hex: 0x4C708A) // Default
                                        : (emotion == targetEmotion ? Color.green : Color.red) // ✅ Feedback colors
                                )
                                .foregroundColor(.white)
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
