import SwiftUI
import SpriteKit

struct BrickBreakerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    @StateObject private var gameController = BrickBreakerGameController()
    @State private var showingStartModal = true
    @State private var showingEndModal = false
    @State private var finalScore = 0
    
    var scene: BrickBreakerScene {
        let scene = BrickBreakerScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                TopNavigationBar(title: "Brick Breaker", onBack: { dismiss() })
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            
            if showingStartModal {
                BrickBreakerStartModal {
                    showingStartModal = false
                }
            }
            
            if showingEndModal {
                EndGameModal(
                    score: finalScore,
                    highScore: gameController.gameModel.highScore,
                    currencyReward: finalScore * 2, // 2 coins per brick
                    onRestart: {
                        showingEndModal = false
                        scene.restartGame()
                    },
                    onBackToMenu: {
                        showingEndModal = false
                        dismiss()
                    }
                )
            }
        }
        .toolbarVisibility(.hidden)
        .onAppear {
            navbarVisibility.isVisible = false
            scene.onGameOver = { score in
                finalScore = score
                gameController.handleGameOver(score: score)
                showingEndModal = true
            }
        }
        .onDisappear {
            navbarVisibility.isVisible = true
        }
    }
}

#Preview {
    BrickBreakerView()
} 
