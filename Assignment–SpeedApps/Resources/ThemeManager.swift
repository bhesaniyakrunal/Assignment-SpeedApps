//
//  ThemeManager.swift
//  Assignment–SpeedApps
//
//  Created by MacBook on 4/6/25.
//

import Foundation
import UIKit
enum AppTheme: String {
    case light, dark
}

class ThemeManager {
    static let shared = ThemeManager()

    private init() {}

    var currentTheme: AppTheme {
        get {
            if let theme = UserDefaults.standard.string(forKey: "selectedTheme"),
               let appTheme = AppTheme(rawValue: theme) {
                return appTheme
            }
            return .light
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
            applyTheme(theme: newValue)
        }
    }

    func applyTheme(theme: AppTheme) {
        let window = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first

        window?.overrideUserInterfaceStyle = (theme == .light) ? .light : .dark
    }
}

