//
//  DasherRegisterController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/14/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit
import Firebase

class DasherRegisterController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: SignInControllerDelegate?
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Dasher Registration"
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
        label.text = "First Name:"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let firstNameField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.placeholder = "First Name"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name:"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lastNameField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.placeholder = "Last Name"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email:"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.placeholder = "your_email@rutgers.edu"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password:"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let passwordField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.placeholder = "Password"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm Password:"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let confirmPasswordField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.placeholder = "Password"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let dormLabel: UILabel = {
        let label = UILabel()
        label.text = "Dorm Building:"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dormField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.placeholder = "Dorm Name"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let dormRoomLabel: UILabel = {
        let label = UILabel()
        label.text = "Dorm Room:"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dormRoomField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.placeholder = "Dorm Room Number"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        
        registrationView.addSubview(firstNameLabel)
        registrationView.addSubview(firstNameField)
        registrationView.addSubview(lastNameLabel)
        registrationView.addSubview(lastNameField)
        registrationView.addSubview(emailLabel)
        registrationView.addSubview(emailField)
        registrationView.addSubview(passwordLabel)
        registrationView.addSubview(passwordField)
        registrationView.addSubview(confirmPasswordLabel)
        registrationView.addSubview(confirmPasswordField)
        registrationView.addSubview(dormLabel)
        registrationView.addSubview(dormField)
        registrationView.addSubview(dormRoomLabel)
        registrationView.addSubview(dormRoomField)
        registrationView.addSubview(registerButton)
        view.addSubview(registrationView)
        
        view.backgroundColor = .white
    }
    
    func setUpAutoLayout() {
        let borderConstant: CGFloat = 20
        let heightConstant: CGFloat = 40
        
        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        // Registration View Section
        registrationView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        registrationView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        registrationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        registrationView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        
        firstNameLabel.topAnchor.constraint(equalTo: registrationView.topAnchor, constant: borderConstant).isActive = true
        firstNameLabel.leftAnchor.constraint(equalTo: registrationView.leftAnchor, constant: borderConstant).isActive = true
        firstNameLabel.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        firstNameField.topAnchor.constraint(equalTo: firstNameLabel.topAnchor).isActive = true
        firstNameField.rightAnchor.constraint(equalTo: registrationView.rightAnchor, constant: -borderConstant).isActive = true
        firstNameField.leftAnchor.constraint(equalTo: firstNameLabel.rightAnchor, constant: borderConstant).isActive = true
        firstNameField.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        // lastname
        lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: borderConstant).isActive = true
        lastNameLabel.leftAnchor.constraint(equalTo: registrationView.leftAnchor, constant: borderConstant).isActive = true
        lastNameLabel.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        lastNameField.topAnchor.constraint(equalTo: lastNameLabel.topAnchor).isActive = true
        lastNameField.leftAnchor.constraint(equalTo: lastNameLabel.rightAnchor, constant: borderConstant).isActive = true
        lastNameField.rightAnchor.constraint(equalTo: registrationView.rightAnchor, constant: -borderConstant).isActive = true
        lastNameField.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        // email
        emailLabel.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: borderConstant).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: registrationView.leftAnchor, constant: borderConstant).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        emailField.topAnchor.constraint(equalTo: emailLabel.topAnchor).isActive = true
        emailField.leftAnchor.constraint(equalTo: emailLabel.rightAnchor, constant: borderConstant).isActive = true
        emailField.rightAnchor.constraint(equalTo: registrationView.rightAnchor, constant: -borderConstant).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        // password
        passwordLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: borderConstant).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo: registrationView.leftAnchor, constant: borderConstant).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        passwordField.topAnchor.constraint(equalTo: passwordLabel.topAnchor).isActive = true
        passwordField.leftAnchor.constraint(equalTo: passwordLabel.rightAnchor, constant: borderConstant).isActive = true
        passwordField.rightAnchor.constraint(equalTo: registrationView.rightAnchor, constant: -borderConstant).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        // confirm password
        confirmPasswordLabel.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: borderConstant).isActive = true
        confirmPasswordLabel.leftAnchor.constraint(equalTo: registrationView.leftAnchor, constant: borderConstant).isActive = true
        confirmPasswordLabel.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        confirmPasswordField.topAnchor.constraint(equalTo: confirmPasswordLabel.topAnchor).isActive = true
        confirmPasswordField.leftAnchor.constraint(equalTo: confirmPasswordLabel.rightAnchor, constant: borderConstant).isActive = true
        confirmPasswordField.rightAnchor.constraint(equalTo: registrationView.rightAnchor, constant: -borderConstant).isActive = true
        confirmPasswordField.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        // dorm
        dormLabel.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: borderConstant).isActive = true
        dormLabel.leftAnchor.constraint(equalTo: registrationView.leftAnchor, constant: borderConstant).isActive = true
        dormLabel.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        dormField.topAnchor.constraint(equalTo: dormLabel.topAnchor).isActive = true
        dormField.leftAnchor.constraint(equalTo: dormLabel.rightAnchor, constant: borderConstant).isActive = true
        dormField.rightAnchor.constraint(equalTo: registrationView.rightAnchor, constant: -borderConstant).isActive = true
        dormField.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        // dorm room number
        dormRoomLabel.topAnchor.constraint(equalTo: dormLabel.bottomAnchor, constant: borderConstant).isActive = true
        dormRoomLabel.leftAnchor.constraint(equalTo: registrationView.leftAnchor, constant: borderConstant).isActive = true
        dormRoomLabel.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        dormRoomField.topAnchor.constraint(equalTo: dormRoomLabel.topAnchor).isActive = true
        dormRoomField.leftAnchor.constraint(equalTo: dormRoomLabel.rightAnchor, constant: borderConstant).isActive = true
        dormRoomField.rightAnchor.constraint(equalTo: registrationView.rightAnchor, constant: -borderConstant).isActive = true
        dormRoomField.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        
        registerButton.bottomAnchor.constraint(equalTo: registrationView.bottomAnchor, constant: -20).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        registerButton.leftAnchor.constraint(equalTo: registrationView.leftAnchor, constant: 40).isActive = true
        registerButton.rightAnchor.constraint(equalTo: registrationView.rightAnchor, constant: -40).isActive = true
    }
    
    // MARK: - Selectors
    
    @objc func registerAction() {
        guard let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let email = emailField.text,
            let password = passwordField.text,
            let confirmPassword = confirmPasswordField.text,
            let dorm = dormField.text,
            let dormRoom = dormRoomField.text
            else {return}
        let dasherFirestore = DasherFirestore()
        let isValidRegistraion = dasherFirestore.isValidRegistration(email: email, dorm: dorm, dormRoom: dormRoom, password: password, confirmPassword: confirmPassword)

        if isValidRegistraion {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if authResult != nil {
                    let uid = Auth.auth().currentUser?.uid
                    let dasher = Dasher(
                        uid: uid!,
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        dorm: dorm,
                        dormRoom: Int(dormRoom)!,
                        completedJobs: []
                    )
                    dasherFirestore.initDasherData(dasher: dasher)
                } else {
                    // TODO: HANDLE_ERROR
                }
            }
        }
        
        delegate?.userDidSignIn(userClass: "dasher")
    }
    
    // MARK: - Helpers
    
}
