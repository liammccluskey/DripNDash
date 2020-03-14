//
//  DasherJobNotificationController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 3/3/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit

class DasherJobNotificationController: UIViewController {
    
    // MARK: - Properties
    
    let jobRequest: JobRequest!
    var delegate: DasherJobNotificationDelegate?
    
    let notificationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Job Assigned to You"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("Accept", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        button.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
        button.backgroundColor = .green
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let rejectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reject", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        button.addTarget(self, action: #selector(rejectAction), for: .touchUpInside)
        button.backgroundColor = .red
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
    
    init(jobRequest: JobRequest) {
        self.jobRequest = jobRequest
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configureUI() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
        
        notificationView.addSubview(headerLabel)
        notificationView.addSubview(dividerLabel)
        notificationView.addSubview(acceptButton)
        notificationView.addSubview(rejectButton)
        view.addSubview(notificationView)
        
        view.backgroundColor = .clear
    }
    
    func setUpAutoLayout() {
        let borderConstant: CGFloat = 20
        
        notificationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        notificationView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        notificationView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -borderConstant).isActive = true
        notificationView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: borderConstant).isActive = true
        
        headerLabel.topAnchor.constraint(equalTo: notificationView.topAnchor, constant: borderConstant).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: notificationView.rightAnchor).isActive =  true
        headerLabel.leftAnchor.constraint(equalTo: notificationView.leftAnchor).isActive = true
        
        dividerLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: borderConstant/4).isActive = true
        dividerLabel.rightAnchor.constraint(equalTo: notificationView.rightAnchor, constant: -borderConstant).isActive = true
        dividerLabel.leftAnchor.constraint(equalTo: notificationView.leftAnchor, constant: borderConstant).isActive = true
        dividerLabel.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        acceptButton.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: -borderConstant).isActive = true
        acceptButton.leftAnchor.constraint(equalTo: notificationView.leftAnchor, constant: borderConstant).isActive = true
        acceptButton.rightAnchor.constraint(equalTo: notificationView.centerXAnchor, constant: -borderConstant).isActive = true
        
        rejectButton.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor, constant: -borderConstant).isActive = true
        rejectButton.rightAnchor.constraint(equalTo: notificationView.rightAnchor, constant: -borderConstant).isActive = true
        rejectButton.leftAnchor.constraint(equalTo: notificationView.centerXAnchor, constant: borderConstant).isActive = true
    }
    
    // MARK: - Selectors
    
    @objc func acceptAction() {
        delegate?.didAccept(jobRequest: jobRequest)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func rejectAction() {
        delegate?.didReject(jobRequest: jobRequest)
        dismiss(animated: true, completion: nil)
    }
}
