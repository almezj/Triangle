import SwiftUI
import SpriteKit

struct BrickBreakerGameView: View {
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    @Environment(\.dismiss) var dismiss
    @StateObject private var gameController = BrickBreakerGameController()
    @State private var showingStartModal = true
    @State private var showingEndModal = false
    @State private var finalScore = 0
    @State private var gameScene: BrickBreakerScene
    
    init() {
        let scene = BrickBreakerScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .fill
        _gameScene = State(initialValue: scene)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TopNavigationBar(title: "Brick Breaker", onBack: { dismiss() })
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
            }
            
            if showingStartModal {
                StartGameModal(
                    title: "Brick Breaker",
                    description: "Break all the bricks! Use the paddle to bounce the ball and destroy all bricks to advance to the next round.",
                    onStart: { 
                        showingStartModal = false
                        gameScene.startGame()
                    },
                    onBack: {
                        dismiss()
                    }
                )
            }
            
            if showingEndModal {
                EndGameModal(
                    score: finalScore,
                    highScore: gameController.gameModel.highScore,
                    currencyReward: finalScore * 2, // 2 coins per brick
                    onRestart: {
                        showingEndModal = false
                        gameScene.restartGame()
                        gameScene.startGame()
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
            gameScene.onGameOver = { score in
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

struct BrickBreakerGameView_Previews: PreviewProvider {
    static var previews: some View {
        BrickBreakerGameView()
            .environmentObject(NavbarVisibility())
    }
} 