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
    @EnvironmentObject var userDataStore: UserDataStore
    @State private var showingStartModal = true
    @State private var showingEndModal = false
    @State private var finalScore = 0
    @State private var currencyReward = 0
    
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
                        // Level and Moves Info
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Level")
                                    .font(.bodyText)
                                    .foregroundColor(ColorTheme.text)
                                Text("\(gameController.gameModel.level)")
                                    .font(.pageSubtitle)
                                    .foregroundColor(ColorTheme.primary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 5) {
                                Text("Moves")
                                    .font(.bodyText)
                                    .foregroundColor(ColorTheme.text)
                                HStack(spacing: 10) {
                                    Text("\(gameController.gameModel.moves)")
                                        .font(.pageSubtitle)
                                        .foregroundColor(ColorTheme.primary)
                                    Text("/")
                                        .font(.pageSubtitle)
                                        .foregroundColor(ColorTheme.text)
                                    Text("\(gameController.gameModel.movesRemaining)")
                                        .font(.pageSubtitle)
                                        .foregroundColor(gameController.gameModel.movesRemaining <= 5 ? ColorTheme.completedLevelColor : ColorTheme.primary)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(ColorTheme.secondary.opacity(0.3))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // Game grid
                        let playAreaSize = min(geometry.size.width - 40, geometry.size.height - 200)
                        ZStack {
                            ColorTheme.background
                                .ignoresSafeArea()
                            
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
            .background(ColorTheme.background)
            .overlay {
                if showingStartModal {
                    StartGameModal(
                        title: "Memory Match",
                        description: "Find matching pairs of cards! You have a limited number of moves to complete each level.",
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
                        currencyReward: currencyReward,
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
                currencyReward = score * 2 // 2 coins per move
                
                // Add currency reward to user's inventory
                if var inventory = userDataStore.userData?.inventory {
                    inventory.currency += currencyReward
                    userDataStore.updateInventory(inventory)
                }
                
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
        .toolbarVisibility(.hidden)
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
