//
//  ContainerController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/14/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit
import Firebase

class DasherHomeController: UIViewController {
    
    // MARK: - Properties
    
    var dasher: Dasher!
    
    var inProgressJobs: [JobRequest] = []
    
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
        label.text = "In Progress Jobs"
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
    
    var tableController: DasherJobsTableController!
    
    let requestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Assign Me a New Job", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(requestAction), for: .touchUpInside)
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
        
        setDasher()
    }
    
    func setDasher() {
        if let uid = Auth.auth().currentUser?.uid {
            let dasherFirestore = DasherFirestore()
            dasherFirestore.delegate = self
            dasherFirestore.getDasher(uid: uid)
        } else {
            print("DasherHomeController Error: uid is nil")
        }
        
    }
    
    // MARK: - Configure
    
    func configureUI() {
        configureNavigationBar()
        
        // Status View Portion
        statusView.addSubview(statusHeader)
        statusView.addSubview(statusDivider)
        statusView.addSubview(requestButton)
        configureTableController()
        statusView.addSubview(tableController.tableView)
        view.addSubview(statusView)
        
        title = "Home"
        view.backgroundColor = .white
    }
    
    func setUpAutoLayout() {
        let borderConstant: CGFloat = 10
        
        statusView.topAnchor.constraint(equalTo: view.topAnchor, constant: borderConstant).isActive = true
        statusView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -borderConstant).isActive = true
        statusView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -borderConstant).isActive = true
        statusView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: borderConstant).isActive = true
        
        statusHeader.topAnchor.constraint(equalTo: statusView.topAnchor, constant: borderConstant/2).isActive = true
        statusHeader.rightAnchor.constraint(equalTo: statusView.rightAnchor).isActive = true
        statusHeader.leftAnchor.constraint(equalTo: statusView.leftAnchor).isActive = true
        
        statusDivider.topAnchor.constraint(equalTo: statusHeader.bottomAnchor, constant: borderConstant/2).isActive = true
        statusDivider.leftAnchor.constraint(equalTo: statusView.leftAnchor, constant: borderConstant).isActive = true
        statusDivider.rightAnchor.constraint(equalTo: statusView.rightAnchor, constant: -borderConstant).isActive = true
        statusDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        requestButton.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: -borderConstant).isActive = true
        requestButton.rightAnchor.constraint(equalTo: statusView.rightAnchor, constant: -borderConstant*3).isActive = true
        requestButton.leftAnchor.constraint(equalTo: statusView.leftAnchor, constant: borderConstant*3).isActive = true
        
        tableController.tableView.topAnchor.constraint(equalTo: statusDivider.bottomAnchor, constant: borderConstant).isActive = true
        tableController.tableView.bottomAnchor.constraint(equalTo: requestButton.topAnchor, constant: -borderConstant).isActive = true
        tableController.tableView.rightAnchor.constraint(equalTo: statusView.rightAnchor, constant: -borderConstant).isActive = true
        tableController.tableView.leftAnchor.constraint(equalTo: statusView.leftAnchor, constant: borderConstant).isActive = true
    }
    
    func configureTableController() {
        tableController = DasherJobsTableController()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x"), style: .plain, target: self, action: #selector(historyAction))
        navigationItem.title = "Home"
    }
    
    // MARK: - Selectors
    
    @objc func requestAction() {
        let jobRequestFirestore = JobRequestFirestore()
        jobRequestFirestore.delegate = self
        jobRequestFirestore.getOldestJobRequest(availableToDasher: dasher)
        
        print("ran DasherHomeController.requestAction()")
    }
    
    func requestActionHelper() {
        print("ran DasherHomeController.requestAction()")
        
        let jobRequestFirestore = JobRequestFirestore()
        jobRequestFirestore.delegate = self
        if dasher != nil {
            jobRequestFirestore.getOldestJobRequest(availableToDasher: dasher)
        } else {
            print("DasherHomeController Error: dasher is nil")
        }
    }
    
    @objc func historyAction() {
        requestActionHelper()
    }
    
}

extension DasherHomeController: JobRequestFirestoreDelegate {
    func sendJobRequest(jobRequest: JobRequest) {
        inProgressJobs.append(jobRequest)
        tableController.tableView.reloadData()
    }
}

extension DasherHomeController: DasherFirestoreDelegate {
    func sendDasher(dasher: Dasher?) {
        if let dasher = dasher {
            self.dasher = dasher
        } else {
            print("DasherHomeController.DasherFirestoreDelegate.sendDasher(): dasher is nil")
        }
    }
}
