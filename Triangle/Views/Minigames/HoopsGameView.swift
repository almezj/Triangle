import SwiftUI
import SpriteKit

struct HoopsGameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    @StateObject private var gameController: HoopsGameController
    @State private var showingStartModal = true
    @State private var showingEndModal = false
    @State private var finalScore = 0
    @State private var unlockedCosmetics: [any Cosmetic] = []
    @State private var gameScene: HoopsGameScene
    
    init() {
        _gameController = StateObject(wrappedValue: HoopsGameController(userDataStore: UserDataStore.shared))
        let scene = HoopsGameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        _gameScene = State(initialValue: scene)
    }
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                TopNavigationBar(
                    title: "Hoops",
                    onBack: { dismiss() }
                )
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
            }
            
            if showingStartModal {
                StartGameModal(
                    title: "Hoops",
                    description: "Swipe to catch the balls! Try to score as many baskets as you can.",
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
                    currencyReward: finalScore, // 1 coin per point
                    unlockedCosmetics: unlockedCosmetics,
                    onRestart: {
                        showingEndModal = false
                        unlockedCosmetics = []
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
                userDataStore.checkMilestones(score: score, gameType: "hoops")
                
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
    HoopsGameView()
} 
