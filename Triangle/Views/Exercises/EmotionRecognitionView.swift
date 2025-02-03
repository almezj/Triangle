import SwiftUI
import RiveRuntime

struct EmotionRecognitionView: View {
    @Environment(\.presentationMode) var presentationMode // ✅ Allows dismissing the view
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

                            if isCorrect == true {
                                onComplete() // ✅ Unlocks next level when correct
                                
                                // ✅ Delay for visual feedback, then navigate back
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    presentationMode.wrappedValue.dismiss() // ✅ Automatically return to Level Selector
                                }
                            } else {
                                // ✅ Reset after delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    selectedEmotion = nil
                                    isCorrect = nil
                                }
                            }
                        }) {
                            Text(emotion.rawValue)
                                .font(.headline)
                                .frame(width: 120, height: 50) // ✅ Fixed size for consistency
                                .background(
                                    selectedEmotion == emotion
                                        ? (isCorrect == true ? Color.green : Color.red) // ✅ Only the clicked button changes
                                        : Color(hex: 0x4C708A) // Default color
                                )
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .animation(.easeInOut(duration: 0.5), value: selectedEmotion) // ✅ Smooth transition effect
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
    }
}
