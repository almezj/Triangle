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
    @State private var showingStartModal = true
    @State private var showingEndModal = false
    @State private var finalScore = 0
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
                    currencyReward: finalScore, // 1 coin per point
                    onRestart: {
                        showingEndModal = false
                        gameScene.restartGame()
                        gameScene.startGame()  // Add this line to start the game after restarting
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
