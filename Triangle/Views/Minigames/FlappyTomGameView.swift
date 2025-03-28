//
//  FlappyTomGameView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 24.03.2025.
//

import SwiftUI
import SpriteKit

struct FlappyTomGameView: View {
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    
    var scene: SKScene {
        let scene = FlappyTomGameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .aspectFill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
//            .toolbarVisibility(.hidden)
            .onAppear {
                navbarVisibility.isVisible = false
            }
            .onDisappear {
                navbarVisibility.isVisible = true
            }
    }
}

struct FlappyBirdGameView_Previews: PreviewProvider {
    static var previews: some View {
        FlappyTomGameView()
            .environmentObject(NavbarVisibility())
    }
}
