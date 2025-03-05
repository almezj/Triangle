//
//  UserData.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import Foundation

struct UserData: Codable {
    var settings: SettingsData
    var progress: ProgressData
    var customization: CustomizationData
}
