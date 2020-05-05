//
//  ContainerController.swift
//  DripNDash
//
//  Created by Liam McCluskey on 2/14/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

// written by: Liam McCluskey
// tested by: Liam McCluskey
// debugged by: Liam McCluskey

import UIKit
import Firebase

class CustomerHomeController: UIViewController {
    
    // MARK: - Test Properties
    
    var dasherChoice: [String:Any] = [:]
    
    var availableDashers: [[String:Any]] = []
    
    var scrollView: UIScrollView!

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var jobRequestFirestore = JobRequestFirestore()
    var customer: Customer!
    var inProgressJobs: [JobRequest] = []
    
    var dashersTableView: UITableView!
    
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
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numLoadsField: UITextField = {
        let textField = UITextField()
        //textField.keyboardType = .numberPad
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Instructions for Handling Your Laundry: "
        label.font = .systemFont(ofSize: 20, weight: .semibold)
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
    
    let dasherChoiceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Dasher Preference:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dasherChoiceValue: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.text = "None"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let clearChoiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear Dasher Preference", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.addTarget(self, action: #selector(clearChoiceAction), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let dasherChoiceInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Click a dasher below if you want to request a specific dasher"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        configureScrollView()
        
        
        // Request View portion
        requestView.addSubview(requestHeader)
        requestView.addSubview(requestDivider)
        requestView.addSubview(numLoadsLabel)
        requestView.addSubview(numLoadsField)
        requestView.addSubview(instructionsLabel)
        requestView.addSubview(instructionsField)
        requestView.addSubview(dasherChoiceLabel)
        requestView.addSubview(dasherChoiceValue)
        requestView.addSubview(clearChoiceButton)
        requestView.addSubview(dasherChoiceInfoLabel)
        configureDashersTableView()
        requestView.addSubview(dashersTableView)
        requestView.addSubview(requestButton)
        containerView.addSubview(requestView)
        
        // Status View portion
        statusView.addSubview(statusHeader)
        statusView.addSubview(statusDivider)
        configureTableController()
        statusView.addSubview(tableController.tableView)
        containerView.addSubview(statusView)
        
        scrollView.addSubview(containerView)
        
        title = "Home"
        view.backgroundColor = .white
    }
    
    func setUpAutoLayout() {
        let borderConstant:CGFloat = 10
        
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: view.frame.height*1.2).isActive = true
        
        
        // Request View portion
        requestView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: borderConstant).isActive = true
        requestView.heightAnchor.constraint(equalToConstant: view.frame.height*0.8).isActive = true
        requestView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -borderConstant).isActive = true
        requestView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: borderConstant).isActive = true
        
        requestHeader.topAnchor.constraint(equalTo: requestView.topAnchor, constant: borderConstant).isActive = true
        requestHeader.rightAnchor.constraint(equalTo: requestView.rightAnchor).isActive = true
        requestHeader.leftAnchor.constraint(equalTo: requestView.leftAnchor).isActive = true
        
        requestDivider.topAnchor.constraint(equalTo: requestHeader.bottomAnchor, constant: borderConstant).isActive = true
        requestDivider.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant).isActive = true
        requestDivider.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant).isActive = true
        requestDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        numLoadsLabel.topAnchor.constraint(equalTo: requestDivider.bottomAnchor, constant: borderConstant).isActive = true
        numLoadsLabel.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant).isActive = true
        
        numLoadsField.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant).isActive = true
        numLoadsField.leftAnchor.constraint(equalTo: numLoadsLabel.rightAnchor, constant: borderConstant).isActive = true
        numLoadsField.centerYAnchor.constraint(equalTo: numLoadsLabel.centerYAnchor).isActive = true
        numLoadsField.heightAnchor.constraint(equalTo: numLoadsLabel.heightAnchor).isActive = true
        
        instructionsLabel.topAnchor.constraint(equalTo: numLoadsLabel.bottomAnchor, constant: borderConstant).isActive = true
        instructionsLabel.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant).isActive = true
        
        instructionsField.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: borderConstant).isActive = true
        instructionsField.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant).isActive = true
        instructionsField.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant).isActive = true
        instructionsField.heightAnchor.constraint(equalTo: instructionsLabel.heightAnchor).isActive = true
        
        //
        dasherChoiceLabel.topAnchor.constraint(equalTo: instructionsField.bottomAnchor, constant: borderConstant).isActive = true
        dasherChoiceLabel.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant).isActive = true
        
        dasherChoiceValue.topAnchor.constraint(equalTo: instructionsField.bottomAnchor, constant: borderConstant).isActive = true
        dasherChoiceValue.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant).isActive = true
        dasherChoiceValue.leftAnchor.constraint(equalTo: dasherChoiceLabel.rightAnchor, constant: borderConstant).isActive = true
        
        clearChoiceButton.topAnchor.constraint(equalTo: dasherChoiceLabel.bottomAnchor, constant: borderConstant).isActive = true
        clearChoiceButton.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant*5).isActive = true
        clearChoiceButton.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant*5).isActive = true
        
        dasherChoiceInfoLabel.topAnchor.constraint(equalTo: clearChoiceButton.bottomAnchor, constant: borderConstant).isActive = true
        dasherChoiceInfoLabel.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant*5).isActive = true
        dasherChoiceInfoLabel.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant*5).isActive = true
        
        //
        
        requestButton.bottomAnchor.constraint(equalTo: requestView.bottomAnchor, constant: -borderConstant).isActive = true
        requestButton.rightAnchor.constraint(equalTo: requestView.rightAnchor, constant: -borderConstant*5).isActive = true
        requestButton.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant*5).isActive = true
        
        dashersTableView.topAnchor.constraint(equalTo: dasherChoiceInfoLabel.bottomAnchor, constant: borderConstant).isActive = true
        dashersTableView.rightAnchor.constraint(equalTo: requestView.rightAnchor,constant: -borderConstant).isActive = true
        dashersTableView.leftAnchor.constraint(equalTo: requestView.leftAnchor, constant: borderConstant).isActive = true
        dashersTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // Status View portion
        statusView.topAnchor.constraint(equalTo: requestView.bottomAnchor, constant: borderConstant).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        statusView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -borderConstant).isActive = true
        statusView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: borderConstant).isActive = true
        
        statusHeader.topAnchor.constraint(equalTo: statusView.topAnchor, constant: borderConstant).isActive = true
        statusHeader.rightAnchor.constraint(equalTo: statusView.rightAnchor).isActive = true
        statusHeader.leftAnchor.constraint(equalTo: statusView.leftAnchor).isActive = true
        
        statusDivider.topAnchor.constraint(equalTo: statusHeader.bottomAnchor, constant: borderConstant).isActive = true
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
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x"), style: .plain, target: self, action: #selector(historyAction))
        navigationItem.title = "Home"
    }
    
    func configureTableController() {
        tableController = CustomerJobsTableController()
        tableController.delegate = self
    }
    
    func configureScrollView() {
        scrollView = UIScrollView(frame: .zero)
        scrollView.isScrollEnabled = true
        //scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 1000)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
    }
    
    func configureDashersTableView() {
        dashersTableView = UITableView()
        dashersTableView.delegate = self
        dashersTableView.dataSource = self
        dashersTableView.translatesAutoresizingMaskIntoConstraints = false
        dashersTableView.layer.cornerRadius = 10
        dashersTableView.clipsToBounds = true
    }
    
    // MARK - Selectors
    
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
    
   
    
    @objc func clearChoiceAction() {
        clearChoiceHelper()
    }
    
    func clearChoiceHelper() {
        DispatchQueue.main.async {
            self.dasherChoiceValue.text = "None"
        }
        dasherChoice = [:]
    }
    
    // MARK: - Helper/Alerts
    
    func showChoiceNotAvailableAlert() {
        let alert = UIAlertController(title: "Dasher not Available", message: "The dasher you chose is no longer accepting requests", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
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
        if dasherChoice.count == 0 { // no specific choice
            jobRequestFirestore.writeJobRequest(jobRequest: jobRequest, isRewrite: false)
        } else { // specific choice for dasher
            let dasherUID = dasherChoice["UID"] as! String
            jobRequestFirestore.writeJobRequest(jobRequest: jobRequest, availableToDasherUID: dasherUID)
        }
        tableController.inProgressJobs.append(jobRequest)
        tableController.addListenerToJobRequest(jobRequest: jobRequest)
        DispatchQueue.main.async {
            self.tableController.tableView.reloadData()
        }
    }
    
    // MARK: - Listeners
    
    func listenForAvailableDashers() {
        let availableDashersRef = Firestore.firestore().collection("dorms")
            .document(customer.dorm)
        availableDashersRef.addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("CJTC.addListenerToJobRequest() Error: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("CJTC.addListenerToJobRequest() Error: Document was empty)")
                return
            }
            let dashers = data["availableDashers"] as! [[String:Any]]
            self.availableDashers = dashers
            DispatchQueue.main.async {
                self.dashersTableView.reloadData()
            }
            // check if chosen dasher is still available
            if self.dasherChoice.count != 0 {
                let stillAvailable = dashers.contains(where: { (dasherDict) -> Bool in
                    let uid = dasherDict["UID"] as! String
                    let dasherUID = self.dasherChoice["UID"] as? String ?? ""
                    return uid == dasherUID
                })
                if !stillAvailable {
                    self.clearChoiceHelper()
                    self.showChoiceNotAvailableAlert()
                }
            }
            
        }
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
        listenForAvailableDashers()
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

extension CustomerHomeController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableDashers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dasherDict = availableDashers[indexPath.row]
        let name = dasherDict["NAME"] as! String
        let rating = dasherDict["RATING"] as! Double
        let roundedRating = String((round(rating*100)/100))
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "Name: \(name)"
        cell.detailTextLabel?.text = "Rating: \(roundedRating)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Dashers Accepting Requests"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dasherDict = availableDashers[indexPath.row]
        dasherChoice = dasherDict
        let name = dasherDict["NAME"] as! String
        DispatchQueue.main.async {
            self.dasherChoiceValue.text = name
        }
    }
    
    
}



