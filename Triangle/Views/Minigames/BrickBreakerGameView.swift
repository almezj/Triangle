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
    @State private var unlockedCosmetics: [any Cosmetic] = []
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
                    unlockedCosmetics: unlockedCosmetics,
                    onRestart: {
                        showingEndModal = false
                        unlockedCosmetics = []
                        gameScene.restartGame()
                        gameScene.startGame()
                    },
                    onBackToMenu: {
                        showingEndModal = false
                        unlockedCosmetics = []
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
                
                // Check for milestone unlocks and store all unlocked cosmetics
                let previousHeadCount = userDataStore.userData?.inventory.unlockedCosmetics.headCosmetics.count ?? 0
                let previousEyeCount = userDataStore.userData?.inventory.unlockedCosmetics.eyeCosmetics.count ?? 0
                
                gameController.handleGameOver(score: score)
                userDataStore.checkMilestones(score: score, gameType: "brickbreaker")
                
                // Get all newly unlocked cosmetics
                if let newHeadCount = userDataStore.userData?.inventory.unlockedCosmetics.headCosmetics.count,
                   newHeadCount > previousHeadCount {
                    let newlyUnlockedHeads = userDataStore.userData?.inventory.unlockedCosmetics.headCosmetics.suffix(newHeadCount - previousHeadCount) ?? []
                    unlockedCosmetics.append(contentsOf: newlyUnlockedHeads)
                }
                
                if let newEyeCount = userDataStore.userData?.inventory.unlockedCosmetics.eyeCosmetics.count,
                   newEyeCount > previousEyeCount {
                    let newlyUnlockedEyes = userDataStore.userData?.inventory.unlockedCosmetics.eyeCosmetics.suffix(newEyeCount - previousEyeCount) ?? []
                    unlockedCosmetics.append(contentsOf: newlyUnlockedEyes)
                }
                
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