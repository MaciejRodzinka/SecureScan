import Foundation
import UIKit

class SettingsManager {
    
    static let shared = SettingsManager()
    
    private let userDefaults = UserDefaults.standard
    
    
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
    
    
    
    var isAutoScanLinksEnabled: Bool {
        get {
            return userDefaults.bool(forKey: Keys.autoScanLinksEnabled)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.autoScanLinksEnabled)
        }
    }
    
    
    
    var isDarkModeEnabled: Bool {
        get {
            return userDefaults.bool(forKey: Keys.darkModeEnabled)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.darkModeEnabled)
            
            
            DispatchQueue.main.async {
                
                let scenes = UIApplication.shared.connectedScenes
                let windowScenes = scenes.compactMap { $0 as? UIWindowScene }
                
                for windowScene in windowScenes {
                    for window in windowScene.windows {
                        
                        window.overrideUserInterfaceStyle = newValue ? .dark : .light
                        
                        
                        if let rootVC = window.rootViewController {
                            self.updateThemeForViewController(rootVC, isDark: newValue)
                        }
                    }
                }
                
                
                NotificationCenter.default.post(name: Notification.Name("DidChangeUserInterfacePreferences"), object: nil)
            }
        }
    }
    
    
    private func updateThemeForViewController(_ viewController: UIViewController, isDark: Bool) {
        
        viewController.view.backgroundColor = isDark ? .systemBackground : .systemBackground
        
        
        if let navController = viewController as? UINavigationController {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = isDark ? .systemBackground : .systemBackground
            
            navController.navigationBar.standardAppearance = appearance
            navController.navigationBar.compactAppearance = appearance
            navController.navigationBar.scrollEdgeAppearance = appearance
            
            
            for childVC in navController.viewControllers {
                updateThemeForViewController(childVC, isDark: isDark)
            }
        }
        
        
        if let tabBarController = viewController as? UITabBarController {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            
            tabBarController.tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBarController.tabBar.scrollEdgeAppearance = appearance
            }
            
            
            if let viewControllers = tabBarController.viewControllers {
                for childVC in viewControllers {
                    updateThemeForViewController(childVC, isDark: isDark)
                }
            }
        }
        
        
        for childVC in viewController.children {
            updateThemeForViewController(childVC, isDark: isDark)
        }
        
        
        if let presentedVC = viewController.presentedViewController {
            updateThemeForViewController(presentedVC, isDark: isDark)
        }
    }
    
    
    
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
    
    
    
    var isFirstLaunch: Bool {
        get {
            return userDefaults.bool(forKey: Keys.firstLaunch)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.firstLaunch)
        }
    }
    
    
    
    var isOnboardingCompleted: Bool {
        get {
            return userDefaults.bool(forKey: Keys.onboardingCompleted)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.onboardingCompleted)
        }
    }
    
    
    
    func saveThreatDatabase(_ data: Data) {
        userDefaults.set(data, forKey: Keys.threatDatabase)
    }
    
    func loadThreatDatabase() -> Data? {
        return userDefaults.data(forKey: Keys.threatDatabase)
    }
    
    
    
    func resetAllSettings() {
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
    }
}
