//
//  TutorialOverlayView.swift
//  Triangle
//
//  Created by Dillon Reilly on 28/03/2025.
//

import SwiftUI

struct TutorialOverlay: View {
    let frame: CGRect
    let message: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .mask(
                    Rectangle()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: frame.width + 16, height: frame.height + 16)
                                .position(x: frame.midX, y: frame.midY)
                                .blendMode(.destinationOut)
                        )
                        .compositingGroup()
                )

            Text(message)
                .font(.title3)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .position(x: frame.midX, y: frame.maxY + 60)
        }
    }
}
