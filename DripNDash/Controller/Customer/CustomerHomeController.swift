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
        label.text = "Request a Dasher"
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
        view.addSubview(requestView)
        
        // History View portion
        historyView.addSubview(historyHeader)
        historyView.addSubview(historyDivider)
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
}
