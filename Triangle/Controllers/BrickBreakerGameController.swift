import SwiftUI

class BrickBreakerGameController: ObservableObject {
    @Published private(set) var gameModel: BrickBreakerGameModel
    
    init() {
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
} 