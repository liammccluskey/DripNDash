//
//  DasherJobHistoryController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 3/26/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit

class DasherJobHistoryController: UIViewController {
    
    // MARK: - Properties
    
    let historyView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var tableController: JobHistoryTableController!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpAutoLayout()
    }
    
    // MARK: - Config
    
    func configureUI(){
        configureNavigationBar()
        
        configureTableController()
        historyView.addSubview(tableController.view)
        view.addSubview(historyView)
        
        view.backgroundColor = .white
        title = "Past Jobs"
    }
    
    func setUpAutoLayout(){
        let border: CGFloat = 10
        historyView.topAnchor.constraint(equalTo: view.topAnchor, constant: border).isActive = true
        historyView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -border).isActive = true
        historyView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -border).isActive = true
        historyView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: border).isActive = true
        
        tableController.tableView.topAnchor.constraint(equalTo: historyView.topAnchor, constant: border).isActive = true
        tableController.tableView.bottomAnchor.constraint(equalTo: historyView.bottomAnchor, constant: -border).isActive = true
        tableController.tableView.rightAnchor.constraint(equalTo: historyView.rightAnchor, constant: -border).isActive = true
        tableController.tableView.leftAnchor.constraint(equalTo: historyView.leftAnchor, constant: border).isActive = true
    }
    
    func configureTableController() {
        tableController = JobHistoryTableController()
        tableController.delegate = self
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(reloadTableData))
        navigationItem.title = "Past Jobs"
    }
    
    // MARK: - Selectors
    
    @objc func reloadTableData() {
        tableController.setCompletedJobs()
    }
}

extension DasherJobHistoryController: JobHistoryTableControllerDelegate {
    func didSelectJob(jobRequest: JobRequest) {
        
    }
}
