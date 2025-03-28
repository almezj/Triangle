//
//  Highlightable.swift
//  Triangle
//
//  Created by Dillon Reilly on 28/03/2025.
//

import SwiftUI

struct HighlightedViewID: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue() 
    }
}

struct Highlightable: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: HighlightedViewID.self,
                        value: proxy.frame(in: .global)
                    )
                }
            )
    }
}
