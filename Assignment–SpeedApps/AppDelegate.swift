//
//  AppDelegate.swift
//  Assignment–SpeedApps
//
//  Created by MacBook on 4/5/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupNavigationBarAppearance()
        setupTabBarAppearance()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
    
    // MARK: - Appearance Setup
    
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor.black
            : UIColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.00)
        }
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor { $0.userInterfaceStyle == .dark ? .white : .white }
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor { $0.userInterfaceStyle == .dark ? .white : .white },
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        let backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
        appearance.backgroundColor = backgroundColor
        
        let selectedColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor.systemBlue
            : UIColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.00)
        }
        
        let normalColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor.lightGray
            : UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.00)
        }
        
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        
        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
        
        UITabBar.appearance().standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
