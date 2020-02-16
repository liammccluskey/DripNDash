//
//  ContainerController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/14/20.
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
    
    func configureHomeController(userClass: String) {
        switch userClass {
        case "customer":
            let controller = CustomerHomeController()
            let embeddedController = UINavigationController(rootViewController: controller)
            present(embeddedController, animated: true)
            break
        case "dasher":
            let controller = DasherHomeController()
            let embeddedController = UINavigationController(rootViewController: controller)
            present(embeddedController, animated: true)
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
    func signIn(userClass: String) {
        configureHomeController(userClass: userClass)
    }
    func register() {
        configureRegisterController()
    }
    
    
}

extension ContainerController: RegisterControllerDelegate {
    func register(userClass: String) {
        configureHomeController(userClass: userClass)
    }
    
    
}
