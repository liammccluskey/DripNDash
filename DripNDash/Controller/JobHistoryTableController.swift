//
//  JobHistoryTableController.swift
//  DripNDash
//
//  Created by Liam McCluskey on 3/26/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

// written by: Liam McCluskey
// tested by: Liam McCluskey
// debugged by: Liam McCluskey

import UIKit
import Firebase


class JobHistoryTableController: UITableViewController {
    
    // MARK: - Properties
    
    var completedJobs: [JobRequest] = []
    
    var delegate: JobHistoryTableControllerDelegate?
    var jrf: JobRequestFirestore!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        
        jrf = JobRequestFirestore()
        jrf.delegate = self
        setCompletedJobs()
    }
    
    // MARK: - Config
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedJobs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let jobRequest = completedJobs[completedJobs.count - (1+indexPath.row)]
        cell.textLabel?.text = jobRequest.getDateTime()
        cell.detailTextLabel?.text = "Amount Paid: $\(jobRequest.amountPaid!)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobRequest = completedJobs[completedJobs.count - (1+indexPath.row)]
        delegate?.didSelectJob(jobRequest: jobRequest)
    }
    
    func setCompletedJobs() {
        let uid = Auth.auth().currentUser?.uid
        let userType = Auth.auth().currentUser?.displayName
        jrf.getCompletedJobs(forUserType: userType!, withUID: uid!)
    }
}

extension JobHistoryTableController: JobRequestFirestoreDelegate {
    func sendAcceptedJobRequest(jobRequest: JobRequest) {
        
    }
    
    func sendJobRequest(jobRequest: JobRequest) {
    }
    
    func sendCompletedJobs(jobRequests: [JobRequest]) {
        self.completedJobs = jobRequests
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
