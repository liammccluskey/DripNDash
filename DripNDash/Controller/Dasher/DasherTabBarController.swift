//
//  DasherTabBarController.swift
//  DripNDash
//
//  Created by Liam McCluskey on 2/15/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

// written by: Liam McCluskey
// tested by: Liam McCluskey
// debugged by: Liam McCluskey

import UIKit

class DasherTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
    }
    
    // MARK: - Config
    
    func configureTabBar() {
        let homeController = DasherHomeController()
        let jobHistoryController = DasherJobHistoryController()
        let settingsController = DasherSettingsController()
        
        let controller1 = UINavigationController(rootViewController: homeController)
        homeController.tabBarItem.image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let controller2 = UINavigationController(rootViewController: jobHistoryController)
        jobHistoryController.tabBarItem.image = #imageLiteral(resourceName: "ic_menu_white_3x")
        let controller3 = UINavigationController(rootViewController: settingsController)
        settingsController.tabBarItem.image = #imageLiteral(resourceName: "baseline_settings_white_24dp")
        
        
        viewControllers = [controller1, controller2, controller3]
        
        // white bar with black items
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
        tabBar.isTranslucent = false
    }
    
}
