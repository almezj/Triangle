import SwiftUI

struct EndGameModal: View {
    let score: Int
    let highScore: Int
    let currencyReward: Int
    let unlockedCosmetics: [any Cosmetic]
    let onRestart: () -> Void
    let onBackToMenu: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Game Over")
                    .font(.pageTitle)
                    .foregroundColor(ColorTheme.text)
                
                VStack(spacing: 15) {
                    // Score and High Score
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Score")
                                .font(.bodyText)
                                .foregroundColor(ColorTheme.text)
                            Text("\(score)")
                                .font(.pageSubtitle)
                                .foregroundColor(ColorTheme.primary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("High Score")
                                .font(.bodyText)
                                .foregroundColor(ColorTheme.text)
                            Text("\(highScore)")
                                .font(.pageSubtitle)
                                .foregroundColor(ColorTheme.primary)
                        }
                    }
                    
                    // Currency Reward
                    HStack {
                        Text("Currency Earned")
                            .font(.bodyText)
                            .foregroundColor(ColorTheme.text)
                        Spacer()
                        HStack(spacing: 5) {
                            Text("\(currencyReward)")
                                .font(.pageSubtitle)
                                .foregroundColor(ColorTheme.currencyColor)
                            Image("currency_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                        }
                    }
                    
                    // Unlocked Cosmetics
                    if !unlockedCosmetics.isEmpty {
                        Text("New Unlocks!")
                            .font(.bodyText)
                            .foregroundColor(ColorTheme.completedLevelColor)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(unlockedCosmetics, id: \.uniqueId) { cosmetic in
                                    HStack(spacing: 15) {
                                        Image(cosmetic.assetName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                        
                                        VStack(alignment: .leading) {
                                            Text(cosmetic.cosmeticTitle)
                                                .font(.pageSubtitle)
                                                .foregroundColor(ColorTheme.text)
                                            Text("Score Milestone Reward")
                                                .font(.caption)
                                                .foregroundColor(ColorTheme.text.opacity(0.7))
                                        }
                                    }
                                    .padding()
                                    .background(ColorTheme.secondary.opacity(0.3))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding()
                .background(ColorTheme.background)
                .cornerRadius(20)
                
                // Buttons
                HStack(spacing: 20) {
                    Button(action: onRestart) {
                        Text("Play Again")
                            .font(.buttonText)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(ColorTheme.primary)
                            .cornerRadius(10)
                    }
                    
                    Button(action: onBackToMenu) {
                        Text("Back to Menu")
                            .font(.buttonText)
                            .foregroundColor(ColorTheme.text)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(ColorTheme.secondary)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(ColorTheme.background)
            .cornerRadius(25)
            .padding()
        }
    }
}

#Preview {
    EndGameModal(
        score: 30,
        highScore: 50,
        currencyReward: 60,
        unlockedCosmetics: [
            HeadCosmetic(
                cosmeticId: 11,
                assetName: "hc_soda_helmet",
                cosmeticTitle: "Soda Helmet",
                relativeScale: 0.6,
                offsetXRatio: 0.00,
                offsetYRatio: -0.28,
                rotation: 0,
                price: 20
            ),
            EyeCosmetic(
                cosmeticId: 6,
                assetName: "ec_8bit_sunglasses",
                cosmeticTitle: "8-Bit Sunglasses",
                relativeScale: 0.6,
                offsetXRatio: 0.00,
                offsetYRatio: -0.28,
                rotation: 0,
                price: 20
            )
        ],
        onRestart: {},
        onBackToMenu: {}
    )
} 
