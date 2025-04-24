import SwiftUI

struct EndGameModal: View {
    let score: Int
    let currencyReward: Int
    let onRestart: () -> Void
    let onBackToMenu: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Game Over")
                    .font(.pageTitle)
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    Text("Score: \(score)")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text("Reward: \(currencyReward) coins")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 15) {
                    Button(action: onRestart) {
                        Text("Restart")
                            .font(.buttonText)
                            .foregroundColor(ColorTheme.secondary)
                            .frame(width: 200, height: 50)
                            .background(ColorTheme.primary)
                            .cornerRadius(25)
                    }
                    
                    Button(action: onBackToMenu) {
                        Text("Back to Menu")
                            .font(.buttonText)
                            .foregroundColor(ColorTheme.primary)
                            .frame(width: 200, height: 50)
                            .background(ColorTheme.secondary)
                            .cornerRadius(25)
                    }
                }
            }
            .padding(30)
            .background(ColorTheme.background)
            .cornerRadius(20)
            .shadow(color: ColorTheme.shadowGray, radius: 10, x: 0, y: 5)
        }
    }
}

#Preview {
    EndGameModal(
        score: 100,
        currencyReward: 50,
        onRestart: {},
        onBackToMenu: {}
    )
} 