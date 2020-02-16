//
//  DasherTabBarController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/15/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

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
        let homeController = UINavigationController(rootViewController: DasherHomeController())
        homeController.tabBarItem.image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let settingsController = UINavigationController(rootViewController: DasherSettingsController())
        settingsController.tabBarItem.image = #imageLiteral(resourceName: "baseline_settings_white_24dp")
        viewControllers = [homeController, settingsController]
        
        tabBar.barTintColor = .black
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
    }
    
}
