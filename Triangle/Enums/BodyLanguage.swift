//
//  BodyLanguage.swift
//  Triangle
//
//  Created by Dillon Reilly on 03/02/2025.
//

import Foundation

enum BodyLanguage: String, CaseIterable {
    case surprised = "Surprised"
    case frustrated = "Frustrated"
    case proud = "Proud"

    /// Returns the correct image filename based on body language
    var imageName: String {
        switch self {
        case .surprised: return "bodylang1.1"
        case .frustrated: return "bodylang1.2"
        case .proud: return "bodylang1.3"
        }
    }

    /// Returns a random body language type
    static func random() -> BodyLanguage {
        return BodyLanguage.allCases.randomElement() ?? .surprised
    }
}
