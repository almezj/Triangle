import SwiftUI
import SpriteKit

struct HoopsGameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    
    var scene: SKScene {
        let scene = HoopsGameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .onAppear {
                    navbarVisibility.isVisible = false
                }
                .onDisappear {
                    navbarVisibility.isVisible = true
                }
        }
    }
}

#Preview {
    HoopsGameView()
} 