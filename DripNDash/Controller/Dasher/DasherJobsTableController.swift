//
//  DasherJobsTableController.swift
//  DripNDash
//
//  Created by Liam McCluskey on 2/25/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

/*  TODO
    - add functionality for item in table selection
    - make custom table view cells
    - update self.inProgressJobs on read from database or listenerDidChange
 
 
*/

import UIKit
import Firebase

class DasherJobsTableController: UITableViewController {
    
    // MARK: - Properties
    
    var inProgressJobs: [JobRequest] = []
    var listeners: [String: ListenerRegistration] = [:]
    
    var delegate: DasherJobsTableControllerDelegate?
    
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
        if jobRequest.wasCancelled {
            cell.textLabel?.text = "Cancelled"
        } else {
            cell.textLabel?.text = jobRequest.currentStatus
        }
        cell.detailTextLabel?.text = jobRequest.jobID
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobRequest = inProgressJobs[indexPath.row]
        delegate?.didSelectJob(jobRequest: jobRequest)
    }
    
    // MARK: Job Cancellation
    
    func addListenerToJobRequest(jobRequest: JobRequest) {
        let inProgressDocRef = Firestore.firestore().collection("jobsInProgress")
            .document(jobRequest.jobID)
        listeners[jobRequest.jobID] =
            inProgressDocRef.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("DJTC.addListenerToJobRequest() Error: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("DJTC.addListenerToJobRequest() Error: Document was empty)")
                    return
                }
                let updatedJobRequest = JobRequest(fromDocData: data)
                if updatedJobRequest.wasCancelled {
                    for i in 0..<self.inProgressJobs.count {
                        let jr = self.inProgressJobs[i]
                        if jr.jobID == updatedJobRequest.jobID {
                            self.inProgressJobs[i].wasCancelled = true
                        }
                    }
                    self.tableView.reloadData()
                    self.didCancelJobRequest(jobRequest: jobRequest)
                }
        }
    }

    func didCancelJobRequest(jobRequest: JobRequest) {
        let jrf = JobRequestFirestore()
        jrf.deleteJobRequest(jobRequest: jobRequest)
        
        listeners.removeValue(forKey: jobRequest.jobID)
    }
}
