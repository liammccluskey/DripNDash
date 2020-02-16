//
//  signinController.swift
//  QuikPark
//
//  Created by Marty McCluskey on 12/31/19.
//  Copyright © 2019 Liam McCluskey. All rights reserved.
//

import UIKit


class SignInController: UIViewController {
    // MARK: - Properties
    
    var delegate: SignInControllerDelegate?
    
    var isSignIn: Bool = true
    
    private let loginView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Drip n' Dash"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signInUpSC: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Log In", "Register"])
        sc.selectedSegmentIndex = 0
        sc.layer.cornerRadius = 5
        sc.backgroundColor = .black
        sc.tintColor = .white
        sc.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    private let emailField: UITextField = {
        let textField = UITextField()
        // LBFTP
        textField.text = "liammail100@gmail.com"
        //
        textField.autocapitalizationType = .none
        textField.placeholder = "Email"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordField: UITextField = {
        let textField = UITextField()
        // LBFTP
        textField.text = "password"
        //
        textField.autocapitalizationType = .none
        textField.placeholder = "Password"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Log In", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(logInButtonAction), for: .touchUpInside)
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
        //// view.addSubview(backgroundImageView)
        
        loginView.addSubview(appNameLabel)
        loginView.addSubview(signInUpSC)
        loginView.addSubview(emailField)
        loginView.addSubview(passwordField)
        loginView.addSubview(loginButton)
        view.addSubview(loginView)
        
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
    }
    
    func setUpAutoLayout() {
        loginView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loginView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginView.heightAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true
        
        appNameLabel.topAnchor.constraint(equalTo: loginView.topAnchor).isActive = true
        appNameLabel.rightAnchor.constraint(equalTo: loginView.rightAnchor, constant: -20).isActive = true
        appNameLabel.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 20).isActive = true
        appNameLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        signInUpSC.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 30).isActive = true
        signInUpSC.rightAnchor.constraint(equalTo: loginView.rightAnchor, constant: -100).isActive = true
        signInUpSC.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 100).isActive = true
        signInUpSC.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        emailField.topAnchor.constraint(equalTo: signInUpSC.bottomAnchor, constant: 80).isActive = true
        emailField.rightAnchor.constraint(equalTo: loginView.rightAnchor, constant: -20).isActive = true
        emailField.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 20).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20).isActive = true
        passwordField.rightAnchor.constraint(equalTo: loginView.rightAnchor, constant: -20).isActive = true
        passwordField.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 20).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20).isActive = true
        loginButton.rightAnchor.constraint(equalTo: loginView.rightAnchor, constant: -20).isActive = true
        loginButton.leftAnchor.constraint(equalTo: loginView.leftAnchor, constant: 20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Selectors
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        isSignIn = !isSignIn
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            loginButton.setTitle("Log In", for: .normal)
            break
        case 1:
            loginButton.setTitle("Register", for: .normal)
            break
        default:
            break
        }
    }
    
    // Assumes user signs in as customer
    @objc func logInButtonAction (sender: UIButton!) {
        let isLogIn = signInUpSC.selectedSegmentIndex == 0 ? true : false
        if isLogIn {
            delegate?.signIn(userClass: "customer")
            hideThisViewController()
        } else {
            let controller = RegisterController()
            navigationController?.pushViewController(controller, animated: true)
        }
/*
        if isLogIn {
            delegate?.signIn(userClass: "customer")
            hideThisViewController()
        } else {
            delegate?.register()
            hideThisViewController()
        }
*/
    }
    
    // MARK: - Handlers
    
    func hideThisViewController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
}
