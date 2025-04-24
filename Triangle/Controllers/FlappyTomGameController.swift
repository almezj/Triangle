import SwiftUI

class FlappyTomGameController: ObservableObject {
    @Published private(set) var gameModel: FlappyTomGameModel
    
    init() {
        self.gameModel = FlappyTomGameModel()
        // Load high score from UserDefaults
        self.gameModel.highScore = UserDefaults.standard.integer(forKey: "FlappyTomHighScore")
    }
    
    func updateHighScore(_ newScore: Int) {
        gameModel.highScore = newScore
        // Save new high score
        UserDefaults.standard.set(gameModel.highScore, forKey: "FlappyTomHighScore")
    }
    
    func resetGame() {
        gameModel.score = 0
        gameModel.isGameActive = true
    }
} 