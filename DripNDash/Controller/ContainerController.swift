//
//  ContainerController.swift
//  DripNDash
//
//  Created by Liam McCluskey on 2/14/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSignInController()
    }
    
    // MARK: - Configure
    
    func configureSignInController() {
        let controller = SignInController()
        controller.delegate = self
        let embeddedController = UINavigationController(rootViewController: controller)
        showChildViewController(child: embeddedController)
    }
    
    func configureRegisterController() {
        let controller = RegisterController()
        controller.delegate = self
        showChildViewController(child: controller)
    }
    
    func configureTabBarController(userClass: String) {
        switch userClass {
        case "customer":
            let controller = CustomerTabBarController()
            showChildViewController(child: controller)
            break
        case "dasher":
            let controller = DasherTabBarController()
            showChildViewController(child: controller)
            break
        default:
            break
        }
    }
    
    // MARK: - Handlers
    
    func showChildViewController(child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        didMove(toParent: self)
    }
}

extension ContainerController: SignInControllerDelegate {
    func userDidSignIn(userClass: String) {
        configureTabBarController(userClass: userClass)
    }
}
