import SwiftUI
import RiveRuntime

struct EmotionRecognitionView: View {
    let onComplete: () -> Void
    @State private var targetEmotion: Emotion
    @State private var selectedEmotion: Emotion? = nil
    @State private var isCorrect: Bool? = nil
    @State private var riveViewModel: RiveViewModel

    init(predefinedEmotion: Emotion? = nil, onComplete: @escaping () -> Void) {
        // ✅ If predefinedEmotion is set, use it. Otherwise, pick a random emotion.
        let initialEmotion = predefinedEmotion ?? Emotion.random()

        self.onComplete = onComplete
        self._targetEmotion = State(initialValue: initialEmotion)
        self._riveViewModel = State(initialValue: RiveViewModel(fileName: "ch_t", animationName: initialEmotion.animationName))
    }

    var body: some View {
        VStack {
            Text("What emotion is the mascot showing?")
                .font(.title)
                .padding()

            // 🎭 Display the Rive animation
            riveViewModel.view()
                .frame(width: 300, height: 300)

            VStack(spacing: 15) {
                ForEach(Emotion.allCases, id: \.self) { emotion in
                    Button(action: {
                        selectedEmotion = emotion
                        isCorrect = (emotion == targetEmotion)
                        
                        if isCorrect == true { // ✅ Unlock the next level when correct
                                onComplete()
                            }
                    }) {
                        Text(emotion.rawValue)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isCorrect == nil ? Color.gray : (isCorrect == true ? Color.green : Color.red))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
    }
}
