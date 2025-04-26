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
    @State private var unlockedCosmetics: [any Cosmetic] = []
    
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
                    unlockedCosmetics: unlockedCosmetics,
                    onRestart: {
                        showingEndModal = false
                        unlockedCosmetics = []
                        scene.restartGame()
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
            scene.onGameOver = { score in
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

#Preview {
    BrickBreakerView()
} 
