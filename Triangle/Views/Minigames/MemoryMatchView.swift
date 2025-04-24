//
//  MemoryMatchView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 28.03.2025.
//

import SwiftUI

struct MemoryMatchView: View {
    @StateObject private var gameController = MemoryGameController()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @State private var showingStartModal = true
    @State private var showingEndModal = false
    @State private var finalScore = 0
    
    private var columns: [GridItem] {
        let size = gameController.getGridSize()
        return Array(repeating: GridItem(.flexible(), spacing: 10), count: size.cols)
    }
    
    private var faceUpCardsCount: Int {
        gameController.gameModel.cards.filter { $0.isFaceUp && !$0.isMatched }.count
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TopNavigationBar(title: "Memory Match", onBack: { dismiss() })
                
                GeometryReader { geometry in
                    VStack(spacing: 20) {
                        // Game grid
                        let playAreaSize = min(geometry.size.width - 40, geometry.size.height - 200)
                        ZStack {
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(gameController.gameModel.cards) { card in
                                    if card.isMatched {
                                        // Show empty space for matched cards
                                        Color.clear
                                            .aspectRatio(1, contentMode: .fit)
                                    } else {
                                        CardView(card: card, isDisabled: faceUpCardsCount >= 2 && !card.isFaceUp)
                                            .onTapGesture {
                                                if faceUpCardsCount < 2 || card.isFaceUp {
                                                    if let index = gameController.gameModel.cards.firstIndex(where: { $0.id == card.id }) {
                                                        gameController.flipCard(at: index)
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                            .frame(width: playAreaSize, height: playAreaSize)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .overlay {
                if showingStartModal {
                    StartGameModal(
                        title: "Memory Match",
                        description: "Find matching pairs of cards! Match all pairs to win.",
                        onStart: {
                            showingStartModal = false
                            gameController.startLevel(1)
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
                        currencyReward: finalScore * 2, // 2 coins per move
                        onRestart: {
                            showingEndModal = false
                            gameController.startLevel(1)
                        },
                        onBackToMenu: {
                            showingEndModal = false
                            dismiss()
                        }
                    )
                }
            }
        }
        .onAppear {
            navbarVisibility.isVisible = false
            gameController.onGameOver = { score in
                finalScore = score
                // Update high score if needed
                if score > gameController.gameModel.highScore {
                    gameController.updateHighScore(score)
                }
                showingEndModal = true
            }
        }
        .onDisappear {
            navbarVisibility.isVisible = true
        }
    }
}

struct CardView: View {
    let card: MemoryCard
    let isDisabled: Bool
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            
            ZStack {
                if card.isFaceUp {
                    base.fill(.white)
                    base.strokeBorder(ColorTheme.primary, lineWidth: 2)
                    Character(characterData: card.characterData, useAnimations: false)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(8)
                } else {
                    base.fill(ColorTheme.primary)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .opacity(isDisabled ? 0.7 : 1.0)
    }
}

#Preview {
    MemoryMatchView()
} 
