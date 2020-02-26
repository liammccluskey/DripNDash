//
//  ContainerController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/14/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit
import Firebase

// without subview portions
class CustomerHomeController: UIViewController {
    
    // MARK: - Test Properties
    
    var customer: Customer!
    var inProgressJobRequests: [JobRequest] = []
    var inProgressJobs: [[String: String]] = [[:]]
    
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
    
    var jobsTableController: CustomerJobsTableController!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpAutoLayout()
        
        setCustomer()
    }
    
    func setCustomer() {
        let uid = Auth.auth().currentUser?.uid
        let customerFirestore = CustomerFirestore()
        customerFirestore.delegate = self
        customerFirestore.getCustomer(uid: uid!)
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
        configureJobsTableController()
        statusView.addSubview(jobsTableController.tableView)
        view.addSubview(statusView)
        
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
        
        requestButton.bottomAnchor.constraint(equalTo: requestView.bottomAnchor, constant: -borderConstant).isActive = true
        requestButton.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant*5).isActive = true
        requestButton.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant*5).isActive = true
        
        // Status View portion
        statusView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: borderConstant/2).isActive = true
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
        
        jobsTableController.tableView.topAnchor.constraint(equalTo: statusDivider.bottomAnchor, constant: borderConstant).isActive = true
        jobsTableController.tableView.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: -borderConstant).isActive = true
        jobsTableController.tableView.rightAnchor.constraint(equalTo: statusView.rightAnchor, constant: -borderConstant).isActive = true
        jobsTableController.tableView.leftAnchor.constraint(equalTo: statusView.leftAnchor, constant: borderConstant).isActive = true
        
        statusButton.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: -borderConstant).isActive = true
        statusButton.rightAnchor.constraint(equalTo: statusView.rightAnchor, constant: -borderConstant*5).isActive = true
        statusButton.leftAnchor.constraint(equalTo: statusView.leftAnchor, constant: borderConstant*5).isActive = true
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x"), style: .plain, target: self, action: #selector(historyAction))
        navigationItem.title = "Home"
    }
    
    func configureJobsTableController() {
        jobsTableController = CustomerJobsTableController()
        jobsTableController.delegateCustom = self
        jobsTableController.inProgressJobs = [
            ["status": "Status: Pending Dasher Assignment",
             "estEndTime": "Estimated Drop Off Time: 11:30 AM"
            ]
        ]
        jobsTableController.tableView.reloadData()
    }
    
    // Selectors
    
    @objc func requestAction() {
        requestActionHelper()
    }
    
    func requestActionHelper() {
        print("Ran method: CustomerHomeController.requestAction()")
        // TEST: submit reqeust with static numLoads data (no text fields fam)
        guard let customer = customer else {return}
        let jobID = UUID().uuidString
        let requestTimestamp = Timestamp(date: Date())
        let jobRequest = JobRequest(jobID: jobID, requestTimestamp: requestTimestamp, numLoads: 1)
        
        let jobRequestFirestore = JobRequestFirestore()
        jobRequestFirestore.writeJobRequest(jobRequest: jobRequest, forCustomer: customer)
        
        // TEST -> get rid of this fam
        let laundryRequest = [
            "status": "Status: Pending Dasher Assignment",
            "estEndTime": "Estimated Drop Off time: 12:30 PM",
            "id": UUID().uuidString
        ]
        jobsTableController.inProgressJobs.append(laundryRequest)
        jobsTableController.tableView.reloadData()
    }
    
    @objc func statusAction() {
        let controller = CustomerJobStatusController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func historyAction() {
        let controller = CustomerJobHistoryController()
        navigationController?.pushViewController(controller, animated: true)
        
        // TODO: Get rid of this, it shouldn't be here
        requestAction()
    }
}

// TEST
extension CustomerHomeController: CustomerJobsTableControllerDelegate {
    func didSelectJob() {
        let controller = CustomerJobStatusController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension CustomerHomeController: CustomerFirestoreDelegate {
    func sendCustomer(customer: Customer?) {
        self.customer = customer
    }
}
