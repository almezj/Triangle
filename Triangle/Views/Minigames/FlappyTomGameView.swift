//
//  FlappyTomGameView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 24.03.2025.
//

import SwiftUI
import SpriteKit

struct FlappyTomGameView: View {
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    @Environment(\.dismiss) var dismiss
    @StateObject private var gameController = FlappyTomGameController()
    @State private var showingStartModal = true
    @State private var showingEndModal = false
    @State private var finalScore = 0
    @State private var unlockedCosmetics: [any Cosmetic] = []
    @State private var gameScene: FlappyTomGameScene
    
    init() {
        let scene = FlappyTomGameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .aspectFill
        _gameScene = State(initialValue: scene)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TopNavigationBar(title: "Flappy Tom", onBack: { dismiss() })
                SpriteView(scene: gameScene)
                .ignoresSafeArea()            
            }
            
            if showingStartModal {
                StartGameModal(
                    title: "Flappy Tom",
                    description: "Tap to make Tom fly! Avoid the obstacles and try to get the highest score.",
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
                
                // Update high score if needed
                if score > gameController.gameModel.highScore {
                    gameController.updateHighScore(score)
                }
                
                userDataStore.checkMilestones(score: score, gameType: "flappytom")
                
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

struct FlappyBirdGameView_Previews: PreviewProvider {
    static var previews: some View {
        FlappyTomGameView()
            .environmentObject(NavbarVisibility())
    }
}
