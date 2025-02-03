import SwiftUI
import RiveRuntime

struct LevelTransitionView: View {
    @State private var navigateToLevelSelector = false
    @State private var riveViewModel = RiveViewModel(fileName: "ch_t", animationName: "Timeline 1") // ✅ Load mascot animation
    
    // ✅ Provide realistic values for navigation
    let totalTriangles: Int
    let currentLevelIndex: Int
    @State private var selectedLevelId: Int? = nil // Needs to be a @State variable
    @State private var displayedInfobite: String = ""

    // ✅ List of simple, child-friendly infobites
    private let infobites = [
        "Smiling can make you feel happier, even when you're sad!",
        "It's okay to feel angry sometimes, but taking deep breaths can help calm you down!",
        "When someone looks away a lot, they might feel shy or nervous.",
        "Crying isn’t bad—it helps let out big feelings!",
        "Hugs and kind words can help when a friend feels sad!"
    ]

    var body: some View {
        ZStack {
            Color(hex: 0xB5CFE3)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) { // 🔹 Adjusted spacing between elements
                Spacer() // 🔹 Keeps content centered

                riveViewModel.view()
                    .frame(width: 300, height: 300)
                    .padding(.bottom, 20) // 🔹 Adds extra space below the animation

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: 0x4C708A)))
                    .scaleEffect(2)

                Spacer(minLength: 60) // 🔹 Moves text lower while keeping layout balanced

                // ✅ Infobite with improved background styling
                Text(displayedInfobite)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(hex: 0x4C708A))
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: 320)
                    .background(Color(hex: 0x96B6CF).opacity(0.85)) // ✅ Themed background
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)

                Spacer() // 🔹 Ensures everything remains vertically balanced
            }
        }
        .onAppear {
            displayedInfobite = infobites.randomElement() ?? "Emotions help us understand the world!"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                navigateToLevelSelector = true
            }
        }
        .navigationDestination(isPresented: $navigateToLevelSelector) {
            LevelSelectorView(
                totalTriangles: totalTriangles,
                currentLevelIndex: currentLevelIndex,
                selectedLevelId: $selectedLevelId // ✅ Pass Binding<Int?>
            )
        }
    }
}
