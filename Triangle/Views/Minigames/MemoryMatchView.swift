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
    @State private var unlockedCosmetics: [any Cosmetic] = []
    
    private var columns: [GridItem] {
        let size = gameController.getGridSize()
        return Array(repeating: GridItem(.flexible(), spacing: 10), count: size.cols)
    }
    
    private var faceUpCardsCount: Int {
        gameController.gameModel.cards.filter { $0.isFaceUp && !$0.isMatched }.count
    }
    
    private var isTwoCardsFaceUp: Bool {
        faceUpCardsCount == 2
    }
    
    private var movesRemainingColor: Color {
        gameController.gameModel.movesRemaining <= 5 ? ColorTheme.completedLevelColor : ColorTheme.primary
    }
    
    private var matchedPairsCount: Int {
        gameController.gameModel.cards.filter { $0.isMatched }.count / 2
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TopNavigationBar(title: "Memory Match", onBack: { dismiss() })
                
                GeometryReader { geometry in
                    VStack(spacing: 20) {
                        ScoreDisplayView(
                            score: matchedPairsCount,
                            moves: gameController.gameModel.moves,
                            movesRemaining: gameController.gameModel.movesRemaining,
                            movesRemainingColor: movesRemainingColor
                        )
                        
                        let playAreaSize = min(geometry.size.width - 40, geometry.size.height - 200)
                        GameGridView(
                            columns: columns,
                            cards: gameController.gameModel.cards,
                            playAreaSize: playAreaSize,
                            isTwoCardsFaceUp: isTwoCardsFaceUp,
                            onCardTap: { card in
                                if let index = gameController.gameModel.cards.firstIndex(where: { $0.id == card.id }) {
                                    gameController.flipCard(at: index)
                                }
                            }
                        )
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
                        unlockedCosmetics: unlockedCosmetics,
                        onRestart: {
                            showingEndModal = false
                            unlockedCosmetics = []
                            gameController.startLevel(1)
                        },
                        onBackToMenu: {
                            showingEndModal = false
                            unlockedCosmetics = []
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
                
                // Check for milestone unlocks and store all unlocked cosmetics
                let previousHeadCount = userDataStore.userData?.inventory.unlockedCosmetics.headCosmetics.count ?? 0
                let previousEyeCount = userDataStore.userData?.inventory.unlockedCosmetics.eyeCosmetics.count ?? 0
                
                userDataStore.checkMilestones(score: score, gameType: "memory")
                
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
        .toolbarVisibility(.hidden)
    }
}

struct ScoreDisplayView: View {
    let score: Int
    let moves: Int
    let movesRemaining: Int
    let movesRemainingColor: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Score")
                    .font(.bodyText)
                    .foregroundColor(ColorTheme.text)
                Text("\(score)")
                    .font(.pageSubtitle)
                    .foregroundColor(ColorTheme.primary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text("Moves")
                    .font(.bodyText)
                    .foregroundColor(ColorTheme.text)
                HStack(spacing: 10) {
                    Text("\(moves)")
                        .font(.pageSubtitle)
                        .foregroundColor(ColorTheme.primary)
                    Text("/")
                        .font(.pageSubtitle)
                        .foregroundColor(ColorTheme.text)
                    Text("\(movesRemaining)")
                        .font(.pageSubtitle)
                        .foregroundColor(movesRemainingColor)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(ColorTheme.secondary.opacity(0.3))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

struct GameGridView: View {
    let columns: [GridItem]
    let cards: [MemoryCard]
    let playAreaSize: CGFloat
    let isTwoCardsFaceUp: Bool
    let onCardTap: (MemoryCard) -> Void
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(cards) { card in
                if !card.isMatched {
                    CardView(
                        card: card,
                        isDisabled: isTwoCardsFaceUp && !card.isFaceUp,
                        onCardTap: { tappedCard in
                            onCardTap(tappedCard)
                        }
                    )
                    .frame(height: playAreaSize / CGFloat(columns.count))
                } else {
                    // Empty space for matched cards
                    Color.clear
                        .frame(height: playAreaSize / CGFloat(columns.count))
                }
            }
        }
        .padding()
    }
}

struct CardView: View {
    let card: MemoryCard
    let isDisabled: Bool
    let onCardTap: (MemoryCard) -> Void
    
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
        .onTapGesture {
            if !isDisabled {
                onCardTap(card)
            }
        }
    }
}

#Preview {
    MemoryMatchView()
} 
