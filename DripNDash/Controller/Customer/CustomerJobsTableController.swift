//
//  CustomerJobsTableController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/18/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit

class CustomerJobsTableController: UITableViewController {
    
    // MARK: TEST Properties
    
    var delegateCustom: CustomerJobsTableControllerDelegate?
    
    // MARK: - Properties
    
    var inProgressJobs: [[String: String]] = [[:]]
    
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
        let job = inProgressJobs[indexPath.row]
        
        let status = job["status"] ?? "N/A"
        let estEndTime = job["estEndTime"] ?? "N/A"
        cell.textLabel?.text = status
        cell.detailTextLabel?.text = estEndTime
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegateCustom?.didSelectJob()
    }
}
