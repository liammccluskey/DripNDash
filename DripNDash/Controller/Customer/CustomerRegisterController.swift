//
//  CustomerRegisterController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/14/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit

class CustomerRegisterController: UIViewController {
    
    // MARK: - Properties
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Customer Registration"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let registrationView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm Registration", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
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
    
    // MARK: - Config
    
    func configureUI() {
        view.addSubview(headerLabel)
        
        registrationView.addSubview(registerButton)
        view.addSubview(registrationView)
        
        view.backgroundColor = .white
    }
    
    func setUpAutoLayout() {
        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        // Registration View Section
        registrationView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        registrationView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        registrationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        registrationView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        
        registerButton.bottomAnchor.constraint(equalTo: registrationView.bottomAnchor, constant: -20).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        registerButton.leftAnchor.constraint(equalTo: registrationView.leftAnchor, constant: 40).isActive = true
        registerButton.rightAnchor.constraint(equalTo: registrationView.rightAnchor, constant: -40).isActive = true
        
    }
    
    // MARK: - Selectors
    
    @objc func registerAction() {
        // Temporary
        let controller = CustomerTabBarController()
        present(controller, animated: true)
    }
}
