import SwiftUI
import RiveRuntime

struct EmotionRecognitionView: View {
    let onComplete: () -> Void // ✅ Completion handler
    @State private var targetEmotion: Emotion = Emotion.random()
    @State private var selectedEmotion: Emotion? = nil
    @State private var isCorrect: Bool? = nil
    @State private var riveViewModel = RiveViewModel(fileName: "ch_t", animationName: Emotion.random().animationName)

    var body: some View {
        VStack {
            Text("What emotion is the mascot showing?")
                .font(.title)
                .padding()

            riveViewModel.view()
                .frame(width: 300, height: 300)
                .onAppear {
                    riveViewModel.triggerInput(targetEmotion.animationName)
                }

            VStack(spacing: 15) {
                ForEach(Emotion.allCases, id: \.self) { emotion in
                    Button(action: {
                        selectedEmotion = emotion
                        isCorrect = (emotion == targetEmotion)
                        
                        if isCorrect == true {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                onComplete() // ✅ Notify the app that the exercise is completed
                            }
                        }
                    }) {
                        Text(emotion.rawValue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isCorrect == nil ? Color.blue :
                                        (isCorrect == true ? Color.green : Color.red))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }
}

