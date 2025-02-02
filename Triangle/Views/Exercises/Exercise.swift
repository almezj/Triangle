//
//  Exercise.swift
//  Triangle
//
//  Created by Dillon Reilly on 02/02/2025.
//

import SwiftUI

protocol Exercise {
    var id: Int { get }  // Unique ID for each exercise
    var title: String { get }  // Exercise title
    var description: String { get }  // Short description
    var isCompleted: Bool { get set }  // Track progress

    func startExercise() -> AnyView  // Returns the exercise's UI
}
