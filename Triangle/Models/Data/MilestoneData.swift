import Foundation

struct MilestoneData: Codable {
    var hoops: [GameMilestone]
    var memory: [GameMilestone]
    var flappyTom: [GameMilestone]
    var brickBreaker: [GameMilestone]
    
    static let defaultMilestones = MilestoneData(
        hoops: [
            GameMilestone(score: 10, cosmeticId: "head_13", cosmeticType: "head"), // Sport Headband
            GameMilestone(score: 25, cosmeticId: "head_11", cosmeticType: "head"), // Soda Helmet
            GameMilestone(score: 50, cosmeticId: "head_12", cosmeticType: "head")    // 1# Foam Glove
        ],
        memory: [
            GameMilestone(score: 20, cosmeticId: "head_10", cosmeticType: "head") // Wizard Hat
        ],
        flappyTom: [],
        brickBreaker:[
            GameMilestone(score: 10, cosmeticId: "eye_6", cosmeticType: "eye"), // 8-Bit Sunglasses
            GameMilestone(score: 25, cosmeticId: "eye_7", cosmeticType: "eye"), // 8-Bit Sunglasses Gold
            GameMilestone(score: 50, cosmeticId: "eye_8", cosmeticType: "eye"), // 8-Bit Sunglasses Rainbow
        ],
        
    )
}

struct GameMilestone: Codable {
    let score: Int
    let cosmeticId: String
    let cosmeticType: String
} 
