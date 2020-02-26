//
//  CustomerTabBarController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/15/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit

class CustomerTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
    }
    
    // MARK: - Config
    
    func configureTabBar() {
        let homeController = UINavigationController(rootViewController: CustomerHomeController())
        homeController.tabBarItem.image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let settingsController = UINavigationController(rootViewController: CustomerSettingsController())
        settingsController.tabBarItem.image = #imageLiteral(resourceName: "baseline_settings_white_24dp")
        viewControllers = [homeController, settingsController]
        
        // black bar with white items
        //tabBar.barTintColor = .black
        //tabBar.tintColor = .white
        
        // white bar with black items
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
        tabBar.isTranslucent = false
    }
    
}
