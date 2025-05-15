import Foundation
import UIKit

class SettingsManager {
    
    static let shared = SettingsManager()
    
    private let userDefaults = UserDefaults.standard
    
    // Settings keys
    private enum Keys {
        static let notificationsEnabled = "notificationsEnabled"
        static let autoScanLinksEnabled = "autoScanLinksEnabled"
        static let darkModeEnabled = "darkModeEnabled"
        static let securityTipsEnabled = "securityTipsEnabled"
        static let firstLaunch = "firstLaunch"
        static let onboardingCompleted = "onboardingCompleted"
        static let threatDatabase = "threatDatabase"
    }
    
    private init() {
        // Set default values if not set
        if userDefaults.object(forKey: Keys.notificationsEnabled) == nil {
            userDefaults.set(true, forKey: Keys.notificationsEnabled)
        }
        
        if userDefaults.object(forKey: Keys.autoScanLinksEnabled) == nil {
            userDefaults.set(true, forKey: Keys.autoScanLinksEnabled)
        }
        
        if userDefaults.object(forKey: Keys.securityTipsEnabled) == nil {
            userDefaults.set(true, forKey: Keys.securityTipsEnabled)
        }
        
        if userDefaults.object(forKey: Keys.firstLaunch) == nil {
            userDefaults.set(true, forKey: Keys.firstLaunch)
        }
        
        if userDefaults.object(forKey: Keys.onboardingCompleted) == nil {
            userDefaults.set(false, forKey: Keys.onboardingCompleted)
        }
    }
    
    // MARK: - Notifications
    
    var areNotificationsEnabled: Bool {
        get {
            return userDefaults.bool(forKey: Keys.notificationsEnabled)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.notificationsEnabled)
            
            if newValue {
                NotificationManager.shared.requestPermissions { granted in
                    if granted && self.areSecurityTipsEnabled {
                        NotificationManager.shared.scheduleSecurityTip()
                    }
                }
            } else {
                NotificationManager.shared.clearNotifications()
            }
        }
    }
    
    // MARK: - Auto Scan Links
    
    var isAutoScanLinksEnabled: Bool {
        get {
            return userDefaults.bool(forKey: Keys.autoScanLinksEnabled)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.autoScanLinksEnabled)
        }
    }
    
    // MARK: - Dark Mode
    
    var isDarkModeEnabled: Bool {
        get {
            return userDefaults.bool(forKey: Keys.darkModeEnabled)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.darkModeEnabled)
            
            // Zastosuj wybrany motyw do okien aplikacji
            DispatchQueue.main.async {
                // Pobierz wszystkie okna aplikacji
                let scenes = UIApplication.shared.connectedScenes
                let windowScenes = scenes.compactMap { $0 as? UIWindowScene }
                
                for windowScene in windowScenes {
                    for window in windowScene.windows {
                        // Ustaw styl interfejsu w zależności od wybranego motywu
                        window.overrideUserInterfaceStyle = newValue ? .dark : .light
                        
                        // Zaktualizuj również root view controller i jego navigation controller
                        if let rootVC = window.rootViewController {
                            self.updateThemeForViewController(rootVC, isDark: newValue)
                        }
                    }
                }
                
                // Wyślij notyfikację o zmianie motywu, aby wszystkie widoki mogły się zaktualizować
                NotificationCenter.default.post(name: Notification.Name("DidChangeUserInterfacePreferences"), object: nil)
            }
        }
    }
    
    // Rekurencyjnie aktualizuje motyw dla kontrolera widoku i jego dzieci
    private func updateThemeForViewController(_ viewController: UIViewController, isDark: Bool) {
        // Ustaw motyw dla bieżącego view controllera
        viewController.view.backgroundColor = isDark ? .systemBackground : .systemBackground
        
        // Jeśli jest to navigation controller, zaktualizuj jego wygląd
        if let navController = viewController as? UINavigationController {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = isDark ? .systemBackground : .systemBackground
            
            navController.navigationBar.standardAppearance = appearance
            navController.navigationBar.compactAppearance = appearance
            navController.navigationBar.scrollEdgeAppearance = appearance
            
            // Rekurencyjnie zaktualizuj kontrolery widoków w stosie nawigacji
            for childVC in navController.viewControllers {
                updateThemeForViewController(childVC, isDark: isDark)
            }
        }
        
        // Jeśli jest to tab bar controller, zaktualizuj jego wygląd
        if let tabBarController = viewController as? UITabBarController {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            
            tabBarController.tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBarController.tabBar.scrollEdgeAppearance = appearance
            }
            
            // Rekurencyjnie zaktualizuj kontrolery widoków tabów
            if let viewControllers = tabBarController.viewControllers {
                for childVC in viewControllers {
                    updateThemeForViewController(childVC, isDark: isDark)
                }
            }
        }
        
        // Rekurencyjnie zaktualizuj kontrolery widoków dzieci
        for childVC in viewController.children {
            updateThemeForViewController(childVC, isDark: isDark)
        }
        
        // Jeśli jest to modal, zaktualizuj również jego wygląd
        if let presentedVC = viewController.presentedViewController {
            updateThemeForViewController(presentedVC, isDark: isDark)
        }
    }
    
    // MARK: - Security Tips
    
    var areSecurityTipsEnabled: Bool {
        get {
            return userDefaults.bool(forKey: Keys.securityTipsEnabled)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.securityTipsEnabled)
            
            if newValue && areNotificationsEnabled {
                NotificationManager.shared.scheduleSecurityTip()
            } else {
                NotificationManager.shared.clearNotifications()
            }
        }
    }
    
    // MARK: - First Launch
    
    var isFirstLaunch: Bool {
        get {
            return userDefaults.bool(forKey: Keys.firstLaunch)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.firstLaunch)
        }
    }
    
    // MARK: - Onboarding
    
    var isOnboardingCompleted: Bool {
        get {
            return userDefaults.bool(forKey: Keys.onboardingCompleted)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.onboardingCompleted)
        }
    }
    
    // MARK: - Threat Database
    
    func saveThreatDatabase(_ data: Data) {
        userDefaults.set(data, forKey: Keys.threatDatabase)
    }
    
    func loadThreatDatabase() -> Data? {
        return userDefaults.data(forKey: Keys.threatDatabase)
    }
    
    // MARK: - Reset
    
    func resetAllSettings() {
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
    }
}
