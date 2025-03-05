import RiveRuntime
import SwiftUI

struct EmotionRecognitionView: View {
    @Environment(\.presentationMode) var presentationMode
    let onComplete: () -> Void
    @StateObject var controller: EmotionRecognitionController

    init(predefinedEmotion: Emotion? = nil, onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        _controller = StateObject(
            wrappedValue: EmotionRecognitionController(
                predefinedEmotion: predefinedEmotion))
    }

    var body: some View {
        ZStack {
            Color(hex: 0xB5CFE3)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("What emotion is Tom the Triangle showcasing?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: 0x4C708A))
                    .padding(.bottom, 10)

                let riveViewModel = RiveViewModel(
                    fileName: "ch_t",
                    animationName: controller.targetEmotion.animationName)
                riveViewModel.view()
                    .frame(width: 320, height: 320)

                HStack(spacing: 20) {
                    ForEach(controller.availableEmotions, id: \.self) {
                        emotion in
                        Button(action: {
                            controller.checkAnswer(
                                selected: emotion,
                                onComplete: onComplete,
                                dismiss: {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            )
                        }) {
                            Text(emotion.rawValue)
                                .font(.headline)
                                .frame(width: 120, height: 50)
                                .background(
                                    controller.selectedEmotion == emotion
                                        ? (controller.isCorrect == true
                                            ? Color(hex: 0x58D68D)
                                            : Color(hex: 0xEC7063))
                                        : Color(hex: 0x4C708A)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .animation(
                                    .easeInOut(duration: 0.5),
                                    value: controller.selectedEmotion)
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
    }
}

struct EmotionRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        EmotionRecognitionView(onComplete: {
            print("Exercise complete!")
        })
    }
}
