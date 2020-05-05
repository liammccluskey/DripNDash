//
//  CustomerJobsTableController.swift
//  DripNDash
//
//  Created by Liam McCluskey on 2/18/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit
import Firebase

class CustomerJobsTableController: UITableViewController {
    
    // MARK: Properties
    
    var delegate: CustomerJobsTableControllerDelegate?
    
    var listeners: [String: ListenerRegistration] = [:]
    let db = Firestore.firestore()
    
    var inProgressJobs: [JobRequest] = []
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
    }
    
    // MARK: - Config
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inProgressJobs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let jobRequest = inProgressJobs[indexPath.row]
        cell.textLabel?.text = jobRequest.currentStatus
        cell.detailTextLabel?.text = jobRequest.jobID
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectJob(jobRequest: inProgressJobs[indexPath.row])
    }
    
    // MARK: - Firestore Interface
    
    func addListenerToJobRequest(jobRequest: JobRequest) {
        let inProgressDocRef = db.collection("jobsInProgress")
            .document(jobRequest.jobID)
        listeners[jobRequest.jobID] =
            inProgressDocRef.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("CJTC.addListenerToJobRequest() Error: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("CJTC.addListenerToJobRequest() Error: Document was empty)")
                    return
                }
                let jobRequest = JobRequest(fromDocData: data)
                
                for i in 0..<self.inProgressJobs.count {
                    let jr = self.inProgressJobs[i]
                    print("tempJobRequest_ID: \(jr.jobID)")
                    if jr.jobID == jobRequest.jobID {
                        self.inProgressJobs[i] = jobRequest
                    }
                }
                self.tableView.reloadData()
                
                print("CJTC.addListenerToJobRequest(): Value did change")
            }
    }
}
