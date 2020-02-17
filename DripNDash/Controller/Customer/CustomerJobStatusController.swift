//
//  CustomerJobStatusController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/16/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit

class CustomerJobStatusController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpAutoLayout()
    }
    
    // MARK: - Config
    
    func configureUI(){
        
        view.backgroundColor = .white
        title = "Laundry Request Status"
    }
    
    func setUpAutoLayout(){
        
    }
    
    // MARK: - Selectors
}
