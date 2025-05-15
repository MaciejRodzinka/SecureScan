import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupAppearance()
    }
    
    private func setupViewControllers() {
        // Home Tab (Main Dashboard)
        let homeViewController = ViewController()
        let homeNav = UINavigationController(rootViewController: homeViewController)
        homeNav.tabBarItem = UITabBarItem(title: "Główna", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        // SMS Analyzer Tab
        let smsViewController = SMSAnalyzerViewController()
        let smsNav = UINavigationController(rootViewController: smsViewController)
        smsNav.tabBarItem = UITabBarItem(title: "Analiza SMS", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        
        // Education Tab
        let educationViewController = EducationViewController()
        let educationNav = UINavigationController(rootViewController: educationViewController)
        educationNav.tabBarItem = UITabBarItem(title: "Edukacja", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book.fill"))
        
        // Settings Tab
        let settingsViewController = SettingsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsViewController)
        settingsNav.tabBarItem = UITabBarItem(title: "Ustawienia", image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.circle.fill"))
        
        // Set view controllers
        viewControllers = [homeNav, smsNav, educationNav, settingsNav]
    }
    
    private func setupAppearance() {
        // Set appearance for tab bar
        let mainBlue = UIColor(red: 0.0, green: 0.47, blue: 0.8, alpha: 1.0)
        tabBar.tintColor = mainBlue
        
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        } else {
            tabBar.backgroundColor = .white
        }
        
        // Add shadow
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 6
    }
}
