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
                    onRestart: {
                        showingEndModal = false
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

#Preview {
    HoopsGameView()
} 
