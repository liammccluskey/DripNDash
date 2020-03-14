//
//  DasherJobsTableController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/25/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

/*  TODO
    - add functionality for item in table selection
    - make custom table view cells
    - update self.inProgressJobs on read from database or listenerDidChange
 
 
*/

import UIKit

class DasherJobsTableController: UITableViewController {
    
    // MARK: - Properties
    
    var inProgressJobs: [JobRequest] = []
    
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
        cell.textLabel?.text = jobRequest.currentStatus
        cell.detailTextLabel?.text = jobRequest.jobID
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobRequest = inProgressJobs[indexPath.row]
        delegate?.didSelectJob(jobRequest: jobRequest)
    }
    
    
}
