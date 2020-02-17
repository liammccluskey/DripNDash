//
//  ContainerController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/14/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit

class CustomerHomeController: UIViewController {
    
    // MARK: - Properties
    
    let requestPortion: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let requestView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let requestHeader: UILabel = {
        let label = UILabel()
        label.text = "Need Your Laundry Done?"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let requestDivider: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let requestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit Request", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(requestAction), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let statusPortion: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let statusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let statusHeader: UILabel = {
        let label = UILabel()
        label.text = "In Progress Requests"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusDivider: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusButton: UIButton = {
        let button = UIButton()
        button.setTitle("View Status Page", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(statusAction), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let historyPortion: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let historyView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let historyHeader: UILabel = {
        let label = UILabel()
        label.text = "Laundry Request History"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let historyDivider: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let historyButton: UIButton = {
        let button = UIButton()
        button.setTitle("View Full History", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(historyAction), for: .touchUpInside)
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
        configureNavigationBar()
        
        // Request View portion
        
        requestView.addSubview(requestHeader)
        requestView.addSubview(requestDivider)
        requestView.addSubview(requestButton)
        requestPortion.addSubview(requestView)
        view.addSubview(requestPortion)
        
        // Status View portion
        statusView.addSubview(statusHeader)
        statusView.addSubview(statusDivider)
        statusView.addSubview(statusButton)
        statusPortion.addSubview(statusView)
        view.addSubview(statusPortion)
        
        // History View portion
        historyView.addSubview(historyHeader)
        historyView.addSubview(historyDivider)
        historyView.addSubview(historyButton)
        historyPortion.addSubview(historyView)
        view.addSubview(historyPortion)
        
        title = "Home"
        view.backgroundColor = .white
    }
    
    func setUpAutoLayout() {
        let borderConstant:CGFloat = 10
        
        // Request View portion
        requestPortion.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        requestPortion.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        requestPortion.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        requestPortion.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        requestView.topAnchor.constraint(equalTo: requestPortion.topAnchor, constant: borderConstant).isActive = true
        requestView.bottomAnchor.constraint(equalTo: requestPortion.bottomAnchor, constant: -borderConstant/2).isActive = true
        requestView.rightAnchor.constraint(equalTo: requestPortion.rightAnchor, constant: -borderConstant).isActive = true
        requestView.leftAnchor.constraint(equalTo: requestPortion.leftAnchor, constant: borderConstant).isActive = true
        
        requestHeader.topAnchor.constraint(equalTo: requestView.topAnchor, constant: borderConstant/2).isActive = true
        requestHeader.rightAnchor.constraint(equalTo: requestView.rightAnchor).isActive = true
        requestHeader.leftAnchor.constraint(equalTo: requestView.leftAnchor).isActive = true
        
        requestDivider.topAnchor.constraint(equalTo: requestHeader.bottomAnchor, constant: borderConstant/2).isActive = true
        requestDivider.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant).isActive = true
        requestDivider.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant).isActive = true
        requestDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        requestButton.bottomAnchor.constraint(equalTo: requestView.bottomAnchor, constant: -borderConstant).isActive = true
        requestButton.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant*5).isActive = true
        requestButton.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant*5).isActive = true
        
        
        
        // Status View portion
        statusPortion.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        statusPortion.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        statusPortion.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        statusPortion.heightAnchor.constraint(equalToConstant: view.frame.height/5).isActive = true
        
        statusView.topAnchor.constraint(equalTo: statusPortion.topAnchor, constant: borderConstant).isActive = true
        statusView.bottomAnchor.constraint(equalTo: statusPortion.bottomAnchor, constant: -borderConstant/2).isActive = true
        statusView.rightAnchor.constraint(equalTo: statusPortion.rightAnchor, constant: -borderConstant).isActive = true
        statusView.leftAnchor.constraint(equalTo: statusPortion.leftAnchor, constant: borderConstant).isActive = true
        
        statusHeader.topAnchor.constraint(equalTo: statusView.topAnchor, constant: borderConstant/2).isActive = true
        statusHeader.rightAnchor.constraint(equalTo: statusView.rightAnchor).isActive = true
        statusHeader.leftAnchor.constraint(equalTo: statusView.leftAnchor).isActive = true
        
        statusDivider.topAnchor.constraint(equalTo: statusHeader.bottomAnchor, constant: borderConstant/2).isActive = true
        statusDivider.leftAnchor.constraint(equalTo: statusView.leftAnchor, constant: borderConstant).isActive = true
        statusDivider.rightAnchor.constraint(equalTo: statusView.rightAnchor, constant: -borderConstant).isActive = true
        statusDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        statusButton.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: -borderConstant).isActive = true
        statusButton.rightAnchor.constraint(equalTo: statusView.rightAnchor, constant: -borderConstant*5).isActive = true
        statusButton.leftAnchor.constraint(equalTo: statusView.leftAnchor, constant: borderConstant*5).isActive = true
        
        // History View portion
        historyPortion.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        historyPortion.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        historyPortion.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        historyPortion.heightAnchor.constraint(equalToConstant: view.frame.height/5).isActive = true
        
        historyView.topAnchor.constraint(equalTo: historyPortion.topAnchor, constant: borderConstant).isActive = true
        historyView.bottomAnchor.constraint(equalTo: historyPortion.bottomAnchor, constant: -borderConstant/2).isActive = true
        historyView.rightAnchor.constraint(equalTo: historyPortion.rightAnchor, constant: -borderConstant).isActive = true
        historyView.leftAnchor.constraint(equalTo: historyPortion.leftAnchor, constant: borderConstant).isActive = true
        
        historyHeader.topAnchor.constraint(equalTo: historyView.topAnchor, constant: borderConstant/2).isActive = true
        historyHeader.rightAnchor.constraint(equalTo: historyView.rightAnchor).isActive = true
        historyHeader.leftAnchor.constraint(equalTo: historyView.leftAnchor).isActive = true
        
        historyDivider.topAnchor.constraint(equalTo: historyHeader.bottomAnchor, constant: borderConstant/2).isActive = true
        historyDivider.leftAnchor.constraint(equalTo: historyView.leftAnchor, constant: borderConstant).isActive = true
        historyDivider.rightAnchor.constraint(equalTo: historyView.rightAnchor, constant: -borderConstant).isActive = true
        historyDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        historyButton.bottomAnchor.constraint(equalTo: historyView.bottomAnchor, constant: -borderConstant).isActive = true
        historyButton.rightAnchor.constraint(equalTo: historyView.rightAnchor, constant: -borderConstant*5).isActive = true
        historyButton.leftAnchor.constraint(equalTo: historyView.leftAnchor, constant: borderConstant*5).isActive = true
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Home"
    }
    
    // Selectors
    
    @objc func requestAction() {
        
    }
    
    @objc func statusAction() {
        let controller = CustomerJobStatusController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func historyAction() {
        let controller = CustomerJobHistoryController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

/*
import UIKit

class CustomerHomeController: UIViewController {
    
    // MARK: - Properties
    
    let requestView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let requestHeader: UILabel = {
        let label = UILabel()
        label.text = "Need Your Laundry Done?"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let requestDivider: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let requestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit Request", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(requestAction), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let statusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let statusHeader: UILabel = {
        let label = UILabel()
        label.text = "In Progress Requests"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusDivider: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusButton: UIButton = {
        let button = UIButton()
        button.setTitle("View Status Page", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(statusAction), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let historyView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let historyHeader: UILabel = {
        let label = UILabel()
        label.text = "Laundry Request History"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let historyDivider: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let historyButton: UIButton = {
        let button = UIButton()
        button.setTitle("View Full History", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(historyAction), for: .touchUpInside)
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
        configureNavigationBar()
        
        // Request View portion
        requestView.addSubview(requestHeader)
        requestView.addSubview(requestDivider)
        requestView.addSubview(requestButton)
        view.addSubview(requestView)
        
        // Status View portion
        statusView.addSubview(statusHeader)
        statusView.addSubview(statusDivider)
        statusView.addSubview(statusButton)
        view.addSubview(statusView)
        
        // History View portion
        historyView.addSubview(historyHeader)
        historyView.addSubview(historyDivider)
        historyView.addSubview(historyButton)
        view.addSubview(historyView)
        
        title = "Home"
        view.backgroundColor = .white
    }
    
    func setUpAutoLayout() {
        let borderConstant:CGFloat = 10
        
        // Request View portion
        requestView.topAnchor.constraint(equalTo: view.topAnchor, constant: borderConstant).isActive = true
        requestView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -borderConstant/2).isActive = true
        requestView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -borderConstant).isActive = true
        requestView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: borderConstant).isActive = true
        
        requestHeader.topAnchor.constraint(equalTo: requestView.topAnchor, constant: borderConstant/2).isActive = true
        requestHeader.rightAnchor.constraint(equalTo: requestView.rightAnchor).isActive = true
        requestHeader.leftAnchor.constraint(equalTo: requestView.leftAnchor).isActive = true
        
        requestDivider.topAnchor.constraint(equalTo: requestHeader.bottomAnchor, constant: borderConstant/2).isActive = true
        requestDivider.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant).isActive = true
        requestDivider.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant).isActive = true
        requestDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        // Status View portion
        statusView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: borderConstant/2).isActive = true
        statusView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -borderConstant).isActive = true
        statusView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -borderConstant).isActive = true
        statusView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: borderConstant).isActive = true
        
        statusHeader.topAnchor.constraint(equalTo: historyView.topAnchor, constant: borderConstant/2).isActive = true
        statusHeader.rightAnchor.constraint(equalTo: historyView.rightAnchor).isActive = true
        statusHeader.leftAnchor.constraint(equalTo: historyView.leftAnchor).isActive = true
        
        statusDivider.topAnchor.constraint(equalTo: historyHeader.bottomAnchor, constant: borderConstant/2).isActive = true
        statusDivider.leftAnchor.constraint(equalTo: historyView.leftAnchor, constant: borderConstant).isActive = true
        statusDivider.rightAnchor.constraint(equalTo: historyView.rightAnchor, constant: -borderConstant).isActive = true
        statusDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        statusButton.topAnchor.constraint(equalTo: historyView.topAnchor, constant: borderConstant/2).isActive = true
        statusButton.rightAnchor.constraint(equalTo: historyView.rightAnchor).isActive = true
        statusButton.leftAnchor.constraint(equalTo: historyView.leftAnchor).isActive = true
        
        // History View portion
        historyView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: borderConstant/2).isActive = true
        historyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -borderConstant).isActive = true
        historyView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -borderConstant).isActive = true
        historyView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: borderConstant).isActive = true
        
        historyHeader.topAnchor.constraint(equalTo: historyView.topAnchor, constant: borderConstant/2).isActive = true
        historyHeader.rightAnchor.constraint(equalTo: historyView.rightAnchor).isActive = true
        historyHeader.leftAnchor.constraint(equalTo: historyView.leftAnchor).isActive = true
        
        historyDivider.topAnchor.constraint(equalTo: historyHeader.bottomAnchor, constant: borderConstant/2).isActive = true
        historyDivider.leftAnchor.constraint(equalTo: historyView.leftAnchor, constant: borderConstant).isActive = true
        historyDivider.rightAnchor.constraint(equalTo: historyView.rightAnchor, constant: -borderConstant).isActive = true
        historyDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // Selectors
    
    @objc func requestAction() {
        
    }
    
    @objc func statusAction() {
        
    }
    
    @objc func historyAction() {
        
    }
}
*/
