import SpriteKit

class BrickBreakerScene: SKScene, SKPhysicsContactDelegate {
    private var paddle: SKSpriteNode!
    private var ball: SKSpriteNode!
    private var bricks: [SKSpriteNode] = []
    private var score: Int = 0
    private var round: Int = 1
    private var backgroundScoreLabel: SKLabelNode!
    private var gameOverLabel: SKLabelNode!
    private var gameWonLabel: SKLabelNode!
    private var roundLabel: SKLabelNode!
    private var isGameOver: Bool = false
    private var isGameWon: Bool = false
    private var gameStarted: Bool = false
    
    // Game configuration
    private let paddleWidth: CGFloat = 100
    private let paddleHeight: CGFloat = 20
    private let ballSize: CGFloat = 15
    private let baseBrickWidth: CGFloat = 160 
    private let baseBrickHeight: CGFloat = 60
    private let baseBrickSpacing: CGFloat = 10
    private let baseBrickRows: Int = 1
    private let baseBrickColumns: Int = 2
    
    private var currentBrickWidth: CGFloat {
        return baseBrickWidth - CGFloat(round - 1) * 10 // Decrease by 10 each round
    }
    
    private var currentBrickHeight: CGFloat {
        return baseBrickHeight - CGFloat(round - 1) * 5 // Decrease by 5 each round
    }
    
    private var currentBrickSpacing: CGFloat {
        return baseBrickSpacing - CGFloat(round - 1) * 2 // Decrease by 2 each round
    }
    
    private var currentBrickRows: Int {
        return baseBrickRows + (round - 1) * 2 // Add 2 rows per round
    }
    
    private var currentBrickColumns: Int {
        return baseBrickColumns + (round - 1) // Add 1 column per round
    }
    
    private var scoreLabel: SKLabelNode!
    private var livesLabel: SKLabelNode!
    
    var onGameOver: ((Int) -> Void)?
    
    override func didMove(to view: SKView) {
        // Set the scene's scale mode to fill the screen
        scaleMode = .fill
        
        backgroundColor = UIColor(red: 0.71, green: 0.81, blue: 0.89, alpha: 1.0) // B5CFE3
        physicsWorld.contactDelegate = self
        setupGame()
        setupPhysics()
        setupBricks()
        setupLabels()
        setupWalls()
    }
    
    private func setupGame() {
        // Background score label
        backgroundScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        backgroundScoreLabel.text = "0"
        backgroundScoreLabel.fontSize = frame.height * 0.2 // Scale font size relative to screen height
        backgroundScoreLabel.fontColor = UIColor(red: 0.67, green: 0.77, blue: 0.85, alpha: 1.0)
        backgroundScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundScoreLabel.zPosition = -1
        addChild(backgroundScoreLabel)
        
        // Setup paddle with relative size
        let paddleWidth = frame.width * 0.2 // 20% of screen width
        let paddleHeight = frame.height * 0.03 // 3% of screen height
        paddle = SKSpriteNode(color: UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0), 
                            size: CGSize(width: paddleWidth, height: paddleHeight))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + frame.height * 0.15) // 15% from bottom
        addChild(paddle)
        
        // Setup ball
        setupBall()
    }
    
    private func setupPhysics() {
        // Ball physics
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballSize/2)
        ball.physicsBody?.isDynamic = false  // Start with ball not moving
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.mass = 0.05
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.brick | PhysicsCategory.paddle | PhysicsCategory.wall
        ball.physicsBody?.collisionBitMask = PhysicsCategory.paddle | PhysicsCategory.wall | PhysicsCategory.brick
        
        // Paddle physics
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.restitution = 1.0
        paddle.physicsBody?.friction = 0
        paddle.physicsBody?.categoryBitMask = PhysicsCategory.paddle
        paddle.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        
        // Create a frame for the gameplay area
        let gameFrame = SKNode()
        gameFrame.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 100))
        gameFrame.physicsBody?.isDynamic = false
        gameFrame.physicsBody?.restitution = 1.0
        gameFrame.physicsBody?.friction = 0
        gameFrame.physicsBody?.categoryBitMask = PhysicsCategory.wall
        gameFrame.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        addChild(gameFrame)
    }
    
    private func setupBricks() {
        // Calculate available width for bricks (leaving some margin on the sides)
        let availableWidth = frame.width * 0.9 // Use 90% of screen width
        let margin = frame.width * 0.05 // 5% margin on each side
        
        // Calculate brick width and spacing based on number of columns
        let totalSpacing = CGFloat(currentBrickColumns - 1) * (frame.width * 0.02) // 2% spacing between bricks
        let brickWidth = (availableWidth - totalSpacing) / CGFloat(currentBrickColumns)
        let brickHeight = frame.height * 0.05 // 5% of screen height
        let brickSpacing = frame.width * 0.02 // 2% of screen width
        
        // Calculate starting position with margin
        let startX = margin + brickWidth/2
        let startY = frame.height * 0.85 // 85% from bottom
        
        for row in 0..<currentBrickRows {
            for col in 0..<currentBrickColumns {
                let brick = SKSpriteNode(color: UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0), 
                                       size: CGSize(width: brickWidth, height: brickHeight))
                brick.position = CGPoint(
                    x: startX + CGFloat(col) * (brickWidth + brickSpacing),
                    y: startY - CGFloat(row) * (brickHeight + brickSpacing) - brickHeight/2
                )
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.isDynamic = false
                brick.physicsBody?.restitution = 1.0
                brick.physicsBody?.friction = 0
                brick.physicsBody?.categoryBitMask = PhysicsCategory.brick
                brick.physicsBody?.contactTestBitMask = PhysicsCategory.ball
                brick.physicsBody?.collisionBitMask = PhysicsCategory.ball
                addChild(brick)
                bricks.append(brick)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Don't move paddle if game is over or won
        guard !isGameOver && !isGameWon else { return }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Move paddle with touch, keeping it within screen bounds
        let newX = min(max(location.x, paddleWidth/2), frame.width - paddleWidth/2)
        paddle.position.x = newX
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            // Don't restart here, let the view handle it through the modal
            return
        } else if bricks.isEmpty && isGameWon {
            startNextRound()
        } else if !gameStarted {
            gameStarted = true
            ball.physicsBody?.isDynamic = true
            let randomAngle = CGFloat.random(in: -CGFloat.pi/4...CGFloat.pi/4)
            let speed: CGFloat = 400
            let dx = speed * sin(randomAngle)
            let dy = speed * cos(randomAngle)
            ball.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
        }
    }
    
    private func loseLife() {
        guard !isGameOver else { return }
        gameOver()
    }
    
    private func gameOver() {
        guard !isGameOver else { return }
        isGameOver = true
        
        // Stop the ball
        ball.physicsBody?.isDynamic = false
        ball.removeFromParent()
        
        // Removed: in-scene Game Over label
        // The modal in the SwiftUI view will handle the game over UI
        
        // Call onGameOver with the current score
        onGameOver?(score)
    }
    
    private func gameWon() {
        isGameWon = true
        
        // Remove the ball and stop its physics
        ball.physicsBody?.isDynamic = false
        ball.removeFromParent()
        
        // Remove any existing game over labels
        enumerateChildNodes(withName: "gameOverLabel") { node, _ in
            node.removeFromParent()
        }
        
        onGameOver?(score)
    }
    
    private func roundCompleted() {
        // Set game won state
        isGameWon = true
        
        // Remove the ball
        ball.removeFromParent()
        
        // Create round completed label
        let roundLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        roundLabel.text = "Round \(round) Completed!"
        roundLabel.fontSize = frame.height * 0.05 // 5% of screen height
        roundLabel.fontColor = UIColor(red: 0.45, green: 0.69, blue: 0.63, alpha: 1.0) // ColorTheme.completedLevelColor
        roundLabel.position = CGPoint(x: frame.midX, y: frame.midY + frame.height * 0.1)
        roundLabel.name = "roundCompletedLabel"
        addChild(roundLabel)
        
        // Create tap to continue label
        let tapLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        tapLabel.text = "Tap to continue"
        tapLabel.fontSize = frame.height * 0.03 // 3% of screen height
        tapLabel.fontColor = UIColor(red: 0.13, green: 0.58, blue: 0.45, alpha: 1.0) // ColorTheme.currentLevelColor
        tapLabel.position = CGPoint(x: frame.midX, y: frame.midY - frame.height * 0.05)
        tapLabel.name = "tapToContinueLabel"
        addChild(tapLabel)
    }
    
    private func startNextRound() {
        isGameWon = false
        gameStarted = false
        // Remove round completed labels
        enumerateChildNodes(withName: "roundCompletedLabel") { node, _ in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "tapToContinueLabel") { node, _ in
            node.removeFromParent()
        }
        
        // Increment round
        round += 1
        
        // Update labels
        updateLabels()
        
        // Reset ball and paddle positions
        setupBall()
        paddle.position.x = frame.midX
        
        // Setup new bricks
        setupBricks()
    }
    
    // MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Ball hit bottom wall
        if collision == (PhysicsCategory.ball | PhysicsCategory.bottomWall) {
            loseLife()
        }
        
        // Ball hit brick
        if collision == (PhysicsCategory.ball | PhysicsCategory.brick) {
            let brick = (contact.bodyA.categoryBitMask == PhysicsCategory.brick) ? contact.bodyA.node : contact.bodyB.node
            if let brickNode = brick as? SKSpriteNode {
                destroyBrick(brickNode)
            }
        }
        
        // Ball hit paddle - implement angle-based bouncing
        if collision == (PhysicsCategory.ball | PhysicsCategory.paddle) {
            if let velocity = ball.physicsBody?.velocity {
                // Calculate where the ball hit the paddle (0 = center, -1 = left edge, 1 = right edge)
                let paddleCenter = paddle.position.x
                let ballX = ball.position.x
                let paddleHalfWidth = paddleWidth / 2
                let hitPosition = (ballX - paddleCenter) / paddleHalfWidth
                
                // Calculate new velocity based on hit position
                let baseSpeed = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
                let maxAngle: CGFloat = .pi / 3 // 60 degrees
                let angle = hitPosition * maxAngle
                
                // Ensure the ball always goes upward
                let newVelocity = CGVector(
                    dx: baseSpeed * sin(angle),
                    dy: abs(baseSpeed * cos(angle))
                )
                
                ball.physicsBody?.velocity = newVelocity
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard (!isGameOver || !isGameWon) && gameStarted else { return }
        
        // Check if ball went below paddle
        if ball.position.y < paddle.position.y {
            loseLife()
        }
    }
    
    private func destroyBrick(_ brick: SKSpriteNode) {
        // Remove brick from array and scene
        if let index = bricks.firstIndex(of: brick) {
            bricks.remove(at: index)
            brick.removeFromParent()
            
            // Update score
            score += 1
            backgroundScoreLabel.text = "\(score)"
            scoreLabel.text = "Score: \(score)"
            
            // Check if all bricks are destroyed
            if bricks.isEmpty {
                roundCompleted()
            }
        }
    }
    
    private func setupLabels() {
        // Score label
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = frame.height * 0.03 // 3% of screen height
        scoreLabel.fontColor = UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0)
        scoreLabel.position = CGPoint(x: frame.minX + frame.width * 0.2, y: frame.maxY - frame.height * 0.05)
        addChild(scoreLabel)
        
        // Round label
        roundLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        roundLabel.text = "Round: 1"
        roundLabel.fontSize = frame.height * 0.03 // 3% of screen height
        roundLabel.fontColor = UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0)
        roundLabel.position = CGPoint(x: frame.midX, y: frame.maxY - frame.height * 0.05)
        addChild(roundLabel)
    }
    
    private func setupWalls() {
        // Left wall
        let leftWall = SKSpriteNode(color: .clear, size: CGSize(width: 1, height: frame.height))
        leftWall.position = CGPoint(x: frame.minX, y: frame.midY)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        leftWall.physicsBody?.contactTestBitMask = 0
        leftWall.physicsBody?.collisionBitMask = PhysicsCategory.ball
        addChild(leftWall)
        
        // Right wall
        let rightWall = SKSpriteNode(color: .clear, size: CGSize(width: 1, height: frame.height))
        rightWall.position = CGPoint(x: frame.maxX, y: frame.midY)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        rightWall.physicsBody?.contactTestBitMask = 0
        rightWall.physicsBody?.collisionBitMask = PhysicsCategory.ball
        addChild(rightWall)
        
        // Top wall
        let topWall = SKSpriteNode(color: .clear, size: CGSize(width: frame.width, height: 1))
        topWall.position = CGPoint(x: frame.midX, y: frame.maxY)
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        topWall.physicsBody?.contactTestBitMask = 0
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.ball
        addChild(topWall)
        
        // Bottom wall (invisible)
        let bottomWall = SKSpriteNode(color: .clear, size: CGSize(width: frame.width, height: 1))
        bottomWall.position = CGPoint(x: frame.midX, y: frame.minY)
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.isDynamic = false
        bottomWall.physicsBody?.categoryBitMask = PhysicsCategory.bottomWall
        bottomWall.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        bottomWall.physicsBody?.collisionBitMask = 0
        addChild(bottomWall)
    }
    
    private func updateLabels() {
        scoreLabel.text = "Score: \(score)"
        roundLabel.text = "Round: \(round)"
    }
    
    private func setupBall() {
        let ballSize = frame.width * 0.03 // 3% of screen width
        let ballShape = SKShapeNode(circleOfRadius: ballSize/2)
        ballShape.fillColor = UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0)
        ballShape.strokeColor = UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0)
        ballShape.lineWidth = 0
        
        ball = SKSpriteNode()
        ball.addChild(ballShape)
        ball.size = CGSize(width: ballSize, height: ballSize)
        ball.position = CGPoint(x: frame.midX, y: frame.minY + frame.height * 0.2) // 20% from bottom
        addChild(ball)
        
        // Setup ball physics
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballSize/2)
        ball.physicsBody?.isDynamic = false
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.mass = 0.05
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.brick | PhysicsCategory.paddle | PhysicsCategory.wall
        ball.physicsBody?.collisionBitMask = PhysicsCategory.paddle | PhysicsCategory.wall | PhysicsCategory.brick
    }
    
    func startGame() {
        gameStarted = true
        ball.physicsBody?.isDynamic = true
        let randomAngle = CGFloat.random(in: -CGFloat.pi/4...CGFloat.pi/4)
        let speed: CGFloat = 400
        let dx = speed * sin(randomAngle)
        let dy = speed * cos(randomAngle)
        ball.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
    }
    
    func restartGame() {
        // Remove existing ball if it exists
        ball.removeFromParent()
        
        // Reset game state
        isGameOver = false
        isGameWon = false
        score = 0
        round = 1
        gameStarted = false
        
        // Update labels
        backgroundScoreLabel.text = "0"
        scoreLabel.text = "Score: 0"
        roundLabel.text = "Round: 1"
        
        // Reset paddle position
        paddle.position.x = frame.midX
        
        // Setup new ball
        setupBall()
        
        // Remove all bricks and create new ones
        bricks.forEach { $0.removeFromParent() }
        bricks.removeAll()
        setupBricks()
    }
}

// Physics categories for collision detection
private struct PhysicsCategory {
    static let none: UInt32 = 0
    static let ball: UInt32 = 1
    static let paddle: UInt32 = 2
    static let brick: UInt32 = 4
    static let wall: UInt32 = 8
    static let bottomWall: UInt32 = 16
} 