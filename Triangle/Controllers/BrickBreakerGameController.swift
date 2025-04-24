import SwiftUI

class BrickBreakerGameController: ObservableObject {
    @Published private(set) var gameModel: BrickBreakerGameModel
    private let userDataStore: UserDataStore
    
    init(userDataStore: UserDataStore = UserDataStore.shared) {
        self.userDataStore = userDataStore
        self.gameModel = BrickBreakerGameModel()
        // Load high score from UserDefaults
        self.gameModel.highScore = UserDefaults.standard.integer(forKey: "BrickBreakerHighScore")
    }
    
    func updateHighScore(_ newScore: Int) {
        gameModel.highScore = newScore
        // Save new high score
        UserDefaults.standard.set(gameModel.highScore, forKey: "BrickBreakerHighScore")
    }
    
    func resetGame() {
        gameModel.score = 0
        gameModel.isGameActive = true
    }
    
    func handleGameOver(score: Int) {
        // Update high score if needed
        if score > gameModel.highScore {
            updateHighScore(score)
        }
        // Add currency reward (2 coins per brick)
        if var inventory = userDataStore.userData?.inventory {
            inventory.currency += score * 2
            userDataStore.updateInventory(inventory)
        }
    }
} 