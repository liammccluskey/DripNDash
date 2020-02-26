//
//  signinController.swift
//  QuikPark
//
//  Created by Marty McCluskey on 12/31/19.
//  Copyright © 2019 Liam McCluskey. All rights reserved.
//

import UIKit
import Firebase

// LoginView 2
class SignInController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: SignInControllerDelegate?
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Drip 'n Dash"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 60, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logInView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emailField: UITextField = {
        let textField = UITextField()
        // LBFTP
        textField.text = "lmm459@rutgers.edu"
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
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(logInButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(forgotPasswordAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        button.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
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
        logInView.addSubview(emailField)
        logInView.addSubview(passwordField)
        logInView.addSubview(logInButton)
        logInView.addSubview(forgotPasswordButton)
        
        view.addSubview(logInView)
        view.addSubview(appNameLabel)
        view.addSubview(registerButton)
        
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
    }
    
    func setUpAutoLayout() {
        let borderConstant: CGFloat = 10
        
        // view.subViews
        appNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        appNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        appNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        appNameLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        registerButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        registerButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        // logInView.subViews
        logInView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -borderConstant).isActive = true
        logInView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: borderConstant).isActive = true
        logInView.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 100).isActive = true
        logInView.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -100).isActive = true
        
        emailField.topAnchor.constraint(equalTo: logInView.topAnchor, constant: 20).isActive = true
        emailField.rightAnchor.constraint(equalTo: logInView.rightAnchor, constant: -20).isActive = true
        emailField.leftAnchor.constraint(equalTo: logInView.leftAnchor, constant: 20).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20).isActive = true
        passwordField.rightAnchor.constraint(equalTo: logInView.rightAnchor, constant: -20).isActive = true
        passwordField.leftAnchor.constraint(equalTo: logInView.leftAnchor, constant: 20).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        logInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20).isActive = true
        logInButton.rightAnchor.constraint(equalTo: logInView.rightAnchor, constant: -20).isActive = true
        logInButton.leftAnchor.constraint(equalTo: logInView.leftAnchor, constant: 20).isActive = true
        //logInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        forgotPasswordButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 10).isActive = true
        forgotPasswordButton.rightAnchor.constraint(equalTo: logInButton.rightAnchor).isActive = true
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Selectors
    
    @objc func logInButtonAction (sender: UIButton!) {
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if authResult != nil {
                let uid = Auth.auth().currentUser?.uid
                let customerFirestore = CustomerFirestore()
                customerFirestore.delegate = self
                customerFirestore.determineUserClass(uid: uid!)
            } else {
                // TODO: HANDLE_ERROR
            }
            
        }
    }
    
    @objc func forgotPasswordAction() {
        // TODO: pushVC with forgot password stuff
    }
    
    @objc func registerAction() {
        let controller = RegisterController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Handlers
    
    func hideThisViewController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
}

extension SignInController: CustomerFirestoreDelegate {
    func sendCustomer(customer: Customer?) {
        if customer != nil {
            delegate?.userDidSignIn(userClass: "customer")
        } else {
            delegate?.userDidSignIn(userClass: "dasher")
        }
    }
}

extension SignInController: SignInControllerDelegate {
    func userDidSignIn(userClass: String) {
        delegate?.userDidSignIn(userClass: userClass)
    }
}
