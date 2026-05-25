//
//  AppTheme.swift
//  autodoc
//
//  Created by Anatoliy on 25.05.2026.
//

import UIKit

enum AppTheme: Int {
    case system = 0
    case light = 1
    case dark = 2

    var style: UIUserInterfaceStyle {
        switch self {
        case .system: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
}

extension UserDefaults {
    var appTheme: AppTheme {
        get { AppTheme(rawValue: integer(forKey: "appTheme")) ?? .system }
        set { set(newValue.rawValue, forKey: "appTheme") }
    }
}
