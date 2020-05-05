//
//  ContainerController.swift
//  DripNDash
//
//  Created by Liam McCluskey on 2/14/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: SignInControllerDelegate?
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Choose a Type of User"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dasherView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let customerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dasherTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Dasher"
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let customerTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Customer"
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let registerDasherButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register as Dasher", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(registerDasherAction), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let registerCustomerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register as Customer", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(registerCustomerAction), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpAutoLayout()
    }
    
    // MARK: - Configure
    
    func configureUI() {
        view.addSubview(headerLabel)
        
        // Customer View Side
        customerView.addSubview(customerTitle)
        customerView.addSubview(registerCustomerButton)
        view.addSubview(customerView)
        
        // Dasher View Side
        dasherView.addSubview(dasherTitle)
        dasherView.addSubview(registerDasherButton)
        view.addSubview(dasherView)
        
        view.backgroundColor = .white
    }
    
    func setUpAutoLayout() {
        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        // Customer View Side
        customerView.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -5).isActive = true
        customerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        customerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        customerView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        
        customerTitle.topAnchor.constraint(equalTo: customerView.topAnchor, constant: 5).isActive = true
        customerTitle.centerXAnchor.constraint(equalTo: customerView.centerXAnchor).isActive = true
        
        registerCustomerButton.rightAnchor.constraint(equalTo: customerView.rightAnchor, constant: -4).isActive = true
        registerCustomerButton.leftAnchor.constraint(equalTo: customerView.leftAnchor, constant: 4).isActive = true
        registerCustomerButton.bottomAnchor.constraint(equalTo: customerView.bottomAnchor, constant: -20).isActive = true
        registerCustomerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        // Dasher View Side
        dasherView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        dasherView.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 5).isActive = true
        dasherView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        dasherView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        
        dasherTitle.topAnchor.constraint(equalTo: dasherView.topAnchor, constant: 5).isActive = true
        dasherTitle.centerXAnchor.constraint(equalTo: dasherView.centerXAnchor).isActive = true
        
        registerDasherButton.rightAnchor.constraint(equalTo: dasherView.rightAnchor, constant: -4).isActive = true
        registerDasherButton.leftAnchor.constraint(equalTo: dasherView.leftAnchor, constant: 4).isActive = true
        registerDasherButton.bottomAnchor.constraint(equalTo: dasherView.bottomAnchor, constant: -20).isActive = true
        registerDasherButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
    // MARK: - Selectors
    
    @objc func registerCustomerAction() {
        let controller = CustomerRegisterController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func registerDasherAction() {
        let controller = DasherRegisterController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension RegisterController: SignInControllerDelegate {
    func userDidSignIn(userClass: String) {
        delegate?.userDidSignIn(userClass: userClass)
    }
}
