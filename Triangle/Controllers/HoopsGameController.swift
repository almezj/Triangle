import SwiftUI

class HoopsGameController: ObservableObject {
    @Published private(set) var gameModel: HoopsGameModel
    private var screenWidth: CGFloat = 0
    private let userDataStore: UserDataStore
    
    init(userDataStore: UserDataStore = UserDataStore.shared) {
        self.userDataStore = userDataStore
        self.gameModel = HoopsGameModel()
        // Load high score from UserDefaults
        self.gameModel.highScore = UserDefaults.standard.integer(forKey: "HoopsHighScore")
    }
    
    func updateScreenWidth(_ width: CGFloat) {
        screenWidth = width
        // Initialize basket position in the center
        if gameModel.basketPosition == 0 {
            gameModel.basketPosition = width / 2
        }
    }
    
    func randomizeBasketPosition() {
        // Calculate the valid range for basket position
        let minPosition = HoopsGameModel.screenPadding + (HoopsGameModel.basketWidth / 2)
        let maxPosition = screenWidth - HoopsGameModel.screenPadding - (HoopsGameModel.basketWidth / 2)
        
        // Generate random position within valid range
        let randomPosition = CGFloat.random(in: minPosition...maxPosition)
        gameModel.basketPosition = randomPosition
    }
    
    func incrementScore() {
        gameModel.score += 1
        // Update high score if current score is higher
        if gameModel.score > gameModel.highScore {
            updateHighScore(gameModel.score)
        }
        // Randomize basket position for next throw
        randomizeBasketPosition()
    }
    
    func updateHighScore(_ newScore: Int) {
        gameModel.highScore = newScore
        // Save new high score
        UserDefaults.standard.set(gameModel.highScore, forKey: "HoopsHighScore")
    }
    
    func resetGame() {
        gameModel.score = 0
        gameModel.isGameActive = true
        randomizeBasketPosition()
    }
    
    func checkBasketScore(ballPosition: CGPoint) -> Bool {
        let basketLeft = gameModel.basketPosition - (HoopsGameModel.basketWidth / 2)
        let basketRight = gameModel.basketPosition + (HoopsGameModel.basketWidth / 2)
        let basketTop: CGFloat = 100 // Fixed vertical position for the basket
        
        // Check if ball is within basket bounds
        return ballPosition.x >= basketLeft &&
               ballPosition.x <= basketRight &&
               ballPosition.y >= basketTop &&
               ballPosition.y <= basketTop + HoopsGameModel.basketHeight
    }
    
    func handleGameOver(score: Int) {
        // Update high score if needed
        if score > gameModel.highScore {
            updateHighScore(score)
        }
        // Add currency reward (1 coin per point)
        if var inventory = userDataStore.userData?.inventory {
            inventory.currency += score
            userDataStore.updateInventory(inventory)
        }
    }
} 