//
//  CustomerSettingsController.swift
//  DripNDash
//
//  Created by Liam McCluskey on 2/15/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

// written by: Liam McCluskey
// tested by: Liam McCluskey
// debugged by: Liam McCluskey

import UIKit

class CustomerSettingsController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Config
    
    func configureUI() {
        title = "Settings"
        view.backgroundColor = .white
    }
}
