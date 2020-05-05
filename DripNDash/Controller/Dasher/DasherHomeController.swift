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
    
    var notificationLock = DispatchSemaphore(value: 1)
    
    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Accepting Requests", "Not Accepting Requests"])
        //sc.isEnabled = false
        sc.selectedSegmentIndex = 1
        sc.layer.cornerRadius = 5
        sc.backgroundColor = .white
        sc.tintColor = .black
        sc.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    var dasher: Dasher!
    let df = DasherFirestore()
    let jrf = JobRequestFirestore()
    
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
    
    lazy var requestButton: UIButton = {
        let button = UIButton(type: .system)
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
        
        jrf.delegate = self
        df.delegate = self
    }
    
    func setDasher() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DasherHomeController Error: uid is nil")
            return
        }
        df.getDasher(uid: uid)
        df.addListenerToDasher(withUID: uid)
    }
    
    // MARK: - Configure
    
    func configureUI() {
        configureNavigationBar()
        
        view.addSubview(segmentedControl)
        
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
        
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        statusView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: borderConstant).isActive = true
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
        tableController.delegate = self
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x"), style: .plain, target: self, action: #selector(historyAction))
        navigationItem.title = "Home"
    }
    
    // MARK: - Selectors
    
    @objc func requestAction() {
        if dasher != nil {
            jrf.getOldestJobRequest(availableToDasher: dasher)
        } else {
            print("DasherHomeController.requestAction() Error: dasher was nil")
        }
    }
    
    /*
    
    func requestActionHelper() {
        if dasher != nil {
            jrf.getOldestJobRequest(availableToDasher: dasher)
        } else {
            print("DasherHomeController Error: dasher is nil")
        }
    }
    
    @objc func historyAction() {
        requestActionHelper()
    }
 */
    
    @objc func segmentAction() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        let isAvailable = selectedIndex == 0 ? true : false
        df.updateDasherAvailability(forDasher: dasher, isAvailable: isAvailable)
    }
    
    // MARK: - Alerts
    
    func showCustomerRequestNotification(forJobID jobID: String) {
        let alert = UIAlertController(title: "Accept this Request?", message: "A customer has requested specifically for you. Would you like to accept the customer's request?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action) in
           // get job and add it to table
            self.jrf.getInProgressJobRequest(jobID: jobID)
            
        }))
        alert.addAction(UIAlertAction(title: "Reject", style: .destructive, handler: { (action) in
            // delete job from dashers collection and dleete from JIP
            self.jrf.updateOnDasherReject(jobID: jobID)
            
        }))

        
        present(alert, animated: true)
    }
}

extension DasherHomeController: JobRequestFirestoreDelegate {
    func sendJobRequest(jobRequest: JobRequest) {
        print("DasherHomeController.JobRequestFirestoreDelegate.sendJobRequest(): sent job with ID \(jobRequest.jobID)")

        let controller = DasherJobNotificationController(jobRequest: jobRequest)
        controller.delegate = self
        present(controller, animated: true)
    }
    func sendCompletedJobs(jobRequests: [JobRequest]) {
    }
    func sendAcceptedJobRequest(jobRequest: JobRequest) {
        jobRequest.updateOnAssignment(toDasher: dasher, atTime: Timestamp(date: Date()))
        jrf.updateOnAssignmentAccept(jobRequest: jobRequest)
        
        tableController.inProgressJobs.append(jobRequest)
        tableController.addListenerToJobRequest(jobRequest: jobRequest)
        tableController.tableView.reloadData()
    }
}

extension DasherHomeController: DasherFirestoreDelegate {
    func sendDasher(dasher: Dasher?) {
        if let dasher = dasher {
            self.dasher = dasher
            segmentedControl.isEnabled = true
            
        } else {
            print("DasherHomeController.DasherFirestoreDelegate.sendDasher(): dasher is nil")
        }
    }
    func sendRequestsPendingAccept(jobIDs: [String]) {
        for jobID in jobIDs {
            showCustomerRequestNotification(forJobID: jobID)
        }
    }
}

extension DasherHomeController: DasherJobNotificationDelegate {
    func didReject(jobRequest: JobRequest) {
        let jrf = JobRequestFirestore()
        jrf.writeJobRequest(jobRequest: jobRequest, isRewrite: true)
    }
    
    func didAccept(jobRequest: JobRequest) {
        jobRequest.updateOnAssignment(toDasher: dasher, atTime: Timestamp(date: Date()))
        jrf.updateOnAssignmentAccept(jobRequest: jobRequest)
        
        tableController.inProgressJobs.append(jobRequest)
        tableController.addListenerToJobRequest(jobRequest: jobRequest)
        tableController.tableView.reloadData()
    }
}

extension DasherHomeController: DasherJobsTableControllerDelegate {
    func didSelectJob(jobRequest: JobRequest) {
        let controller = DasherJobStatusController(jobRequest: jobRequest)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension DasherHomeController: DasherJobStatusControllerDelegate {
    func didComplete(jobRequest: JobRequest) {
        tableController.inProgressJobs.removeAll { (jr) -> Bool in
            jr.jobID == jobRequest.jobID
        }
        tableController.tableView.reloadData()
        tableController.listeners.removeValue(forKey: jobRequest.jobID)
    }
    func didUpdate(jobRequest: JobRequest) {
        for i in 0..<tableController.inProgressJobs.count {
            let jr = tableController.inProgressJobs[i]
            print("tempJobRequest_ID: \(jr.jobID)")
            if jr.jobID == jobRequest.jobID {
                tableController.inProgressJobs[i] = jobRequest
                print("DJSCD_Delegate.didUpdate(): did update corresponding JR")
            }
        }
        tableController.tableView.reloadData()
    }
}
