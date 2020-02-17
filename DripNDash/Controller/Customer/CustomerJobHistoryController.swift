//
//  CustomerJobHistoryController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/16/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit

class CustomerJobHistoryController: UIViewController {
    
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
        title = "Laundry Request History"
    }
    
    func setUpAutoLayout(){
        
    }
    
    // MARK: - Selectors
}
