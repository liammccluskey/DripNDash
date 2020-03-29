//
//  ContainerController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/14/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit
import Firebase

class CustomerHomeController: UIViewController {
    
    // MARK: - Test Properties
    
    var jobRequestFirestore = JobRequestFirestore()
    var customer: Customer!
    var inProgressJobs: [JobRequest] = []
    
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
    
    let numLoadsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Estimated Number of Loads:"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numLoadsField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Instructions for Handling Your Laundry: "
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instructionsField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let requestButton: UIButton = {
        let button = UIButton(type: .system)
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
    
    var tableController: CustomerJobsTableController!
    
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
        requestView.addSubview(numLoadsLabel)
        requestView.addSubview(numLoadsField)
        requestView.addSubview(instructionsLabel)
        requestView.addSubview(instructionsField)
        requestView.addSubview(requestButton)
        view.addSubview(requestView)
        
        // Status View portion
        statusView.addSubview(statusHeader)
        statusView.addSubview(statusDivider)
        configureTableController()
        statusView.addSubview(tableController.tableView)
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
        
        numLoadsLabel.topAnchor.constraint(equalTo: requestDivider.bottomAnchor, constant: borderConstant/2).isActive = true
        numLoadsLabel.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant).isActive = true
        
        numLoadsField.leftAnchor.constraint(equalTo: numLoadsLabel.rightAnchor, constant: borderConstant).isActive = true
        numLoadsField.centerYAnchor.constraint(equalTo: numLoadsLabel.centerYAnchor).isActive = true
        numLoadsField.heightAnchor.constraint(equalTo: numLoadsLabel.heightAnchor).isActive = true
        
        instructionsLabel.topAnchor.constraint(equalTo: numLoadsLabel.bottomAnchor, constant: borderConstant/2).isActive = true
        instructionsLabel.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant).isActive = true
    
        requestButton.bottomAnchor.constraint(equalTo: requestView.bottomAnchor, constant: -borderConstant).isActive = true
        requestButton.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant*5).isActive = true
        requestButton.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant*5).isActive = true
        
        instructionsField.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: borderConstant/2).isActive = true
        instructionsField.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant).isActive = true
        instructionsField.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant).isActive = true
        instructionsField.heightAnchor.constraint(equalTo: instructionsLabel.heightAnchor).isActive = true
        
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
        
        tableController.tableView.topAnchor.constraint(equalTo: statusDivider.bottomAnchor, constant: borderConstant).isActive = true
        tableController.tableView.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: -borderConstant).isActive = true
        tableController.tableView.rightAnchor.constraint(equalTo: statusView.rightAnchor, constant: -borderConstant).isActive = true
        tableController.tableView.leftAnchor.constraint(equalTo: statusView.leftAnchor, constant: borderConstant).isActive = true
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x"), style: .plain, target: self, action: #selector(historyAction))
        navigationItem.title = "Home"
    }
    
    func configureTableController() {
        tableController = CustomerJobsTableController()
        tableController.delegate = self
    }
    
    // Selectors
    
    @objc func requestAction() {
        guard let customer = customer,
            let numLoads = numLoadsField.text,
            let instructions = instructionsField.text
            else {return}
        let jobRequest = JobRequest(
            jobID: UUID().uuidString,
            customerUID: customer.uid,
            requestTimestamp: Timestamp(date: Date()),
            numLoadsEstimate: Int(numLoads)!,
            dorm: customer.dorm,
            dormRoom: customer.dormRoom,
            customerName: "\(customer.firstName) \(customer.lastName)",
            customerInstructions: instructions
        )
        showConfirmRequestAlert(forJobRequest: jobRequest)
    }
    
    @objc func historyAction() {
        let controller = CustomerJobHistoryController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helper
    
    func showConfirmRequestAlert(forJobRequest jobRequest: JobRequest) {
        let costEstimate = jobRequest.estimatedTotalCost(forNumLoads: jobRequest.numLoadsEstimate)
        let alert = UIAlertController(title: "Confirm this Laundry Request", message: "Estimated Cost: $\(costEstimate)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel Request", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit Request", style: .default, handler: { (action) in
            self.submitJobRequest(jobRequest: jobRequest)
        }))
        
        self.present(alert, animated: true)
    }
    
    func submitJobRequest(jobRequest: JobRequest) {
        jobRequestFirestore.writeJobRequest(jobRequest: jobRequest, isRewrite: false)
        
        tableController.inProgressJobs.append(jobRequest)
        tableController.tableView.reloadData()
        tableController.addListenerToJobRequest(jobRequest: jobRequest)
    }
}


extension CustomerHomeController: CustomerJobsTableControllerDelegate {
    func didSelectJob(jobRequest: JobRequest) {
        let controller = CustomerJobStatusController(jobRequest: jobRequest)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension CustomerHomeController: CustomerFirestoreDelegate {
    func sendCustomer(customer: Customer?) {
        self.customer = customer
    }
}

extension CustomerHomeController: CustomerJobStatusControllerDelegate {
    func didCancel(jobRequest: JobRequest) {
        tableController.inProgressJobs.removeAll { (jr) -> Bool in
            jr.jobID == jobRequest.jobID
        }
        tableController.tableView.reloadData()
    }
    func didComplete(jobRequest: JobRequest) {
        tableController.inProgressJobs.removeAll { (jr) -> Bool in
            jr.jobID == jobRequest.jobID
        }
        tableController.tableView.reloadData()
        tableController.listeners.removeValue(forKey: jobRequest.jobID)
    }
}

