//
//  DashboardTutorialController.swift
//  Triangle
//
//  Created by Dillon Reilly on 28/03/2025.
//

import SwiftUI

class DashboardTutorialController: ObservableObject {
    @Published var isTutorialActive: Bool = true
    @Published var highlightFrame: CGRect = .zero
}
