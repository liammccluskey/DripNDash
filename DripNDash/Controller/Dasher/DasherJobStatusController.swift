//
//  DasherJobStatusController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 3/6/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//



import UIKit
import Firebase

class DasherJobStatusController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: DasherJobStatusControllerDelegate?
    var listener: ListenerRegistration!
    
    var jobRequest: JobRequest!
    let jrf = JobRequestFirestore()
    let df = DasherFirestore()
    
    let jobInfoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let jobInfoHeader: UILabel = {
        let label = UILabel()
        label.text = "Job Information"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobInfoDivider: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var infoLabelStackView: UIStackView!
    var customerNameLabel: UILabel!
    var customerDormLabel: UILabel!
    var customerDormRoomLabel: UILabel!
    var customerInstructionsLabel: UILabel!
    
    let updateStatusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let updateStatusHeader: UILabel = {
        let label = UILabel()
        label.text = "Update Job Status"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let updateStatusDivider: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var buttonStackView: UIStackView!
    var stage2UpdateButton: UIButton!
    var stage3UpdateButton: UIButton!
    var stage4UpdateButton: UIButton!
    var stage5UpdateButton: UIButton!
    var stage6UpdateButton: UIButton!
    var stage7UpdateButton: UIButton!
    var stage8UpdateButton: UIButton!
    var stage9UpdateButton: UIButton!
    
    let stages: [Int: String] = [
        /*
        During Stage -> After Stage Complete
        */
        0: "Waiting for Dasher to Accept", 1: "Dasher Accepted Request",
        2: "On Way for Pickup", 3: "Picked up Laundry",
        4: "Laundry in Washer", 5: "Finished Washing",
        6: "Laundry in Dryer", 7: "Finished Drying",
        8: "On Way for Drop Off", 9: "Dropped off Laundry"
    ]


    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpAutoLayout()
        
        reloadPageData()
        
        addListenerToJobRequest(jobRequest: jobRequest)
    }
    
    init(jobRequest: JobRequest) {
        self.jobRequest = jobRequest
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.didUpdate(jobRequest: jobRequest)
    }
    
    // MARK: - Config
    
    func configureUI(){
        configureNavigationBar()
        
        // Job Information Section
        customerNameLabel = configureJobInfoLabel(keyLabel: "Customer Name", valueLabel: jobRequest.customerName)
        customerDormLabel = configureJobInfoLabel(keyLabel: "Customer Dorm", valueLabel: jobRequest.dorm)
        customerDormRoomLabel = configureJobInfoLabel(keyLabel: "Customer Dorm Room", valueLabel: String(jobRequest.dormRoom))
        customerInstructionsLabel = configureJobInfoLabel(keyLabel: "Customer Instructions", valueLabel: jobRequest.customerInstructions)
        infoLabelStackView = configureStackView(arrangedSubViews: [
            customerNameLabel,
            customerDormLabel,
            customerDormRoomLabel,
            customerInstructionsLabel
            ])
 
        jobInfoView.addSubview(jobInfoHeader)
        jobInfoView.addSubview(jobInfoDivider)
        jobInfoView.addSubview(infoLabelStackView)
        view.addSubview(jobInfoView)
        
        // Update Status Section
        stage2UpdateButton = configureStatusUpdateButton(titleLabel: stages[2]!)
        stage3UpdateButton = configureStatusUpdateButton(titleLabel: stages[3]!)
        stage4UpdateButton = configureStatusUpdateButton(titleLabel: stages[4]!)
        stage5UpdateButton = configureStatusUpdateButton(titleLabel: stages[5]!)
        stage6UpdateButton = configureStatusUpdateButton(titleLabel: stages[6]!)
        stage7UpdateButton = configureStatusUpdateButton(titleLabel: stages[7]!)
        stage8UpdateButton = configureStatusUpdateButton(titleLabel: stages[8]!)
        stage9UpdateButton = configureStatusUpdateButton(titleLabel: stages[9]!)
        buttonStackView = configureStackView(arrangedSubViews:[
            stage2UpdateButton,
            stage3UpdateButton,
            stage4UpdateButton,
            stage5UpdateButton,
            stage6UpdateButton,
            stage7UpdateButton,
            stage8UpdateButton,
            stage9UpdateButton
            ])
        
        updateStatusView.addSubview(updateStatusHeader)
        updateStatusView.addSubview(updateStatusDivider)
        updateStatusView.addSubview(buttonStackView)
        view.addSubview(updateStatusView)
        
        view.backgroundColor = .white
    }
    
    func setUpAutoLayout(){
        let borderConstant: CGFloat = 10
        
        // Job Information Section
        jobInfoView.topAnchor.constraint(equalTo: view.topAnchor, constant: borderConstant).isActive = true
        jobInfoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -borderConstant).isActive = true
        jobInfoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: borderConstant).isActive = true
        jobInfoView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        
        jobInfoHeader.topAnchor.constraint(equalTo: jobInfoView.topAnchor, constant: borderConstant/2).isActive = true
        jobInfoHeader.centerXAnchor.constraint(equalTo: jobInfoView.centerXAnchor).isActive = true
        
        jobInfoDivider.topAnchor.constraint(equalTo: jobInfoHeader.bottomAnchor, constant: borderConstant/2).isActive = true
        jobInfoDivider.rightAnchor.constraint(equalTo: jobInfoView.rightAnchor, constant: -borderConstant).isActive = true
        jobInfoDivider.leftAnchor.constraint(equalTo: jobInfoView.leftAnchor, constant: borderConstant).isActive = true
        jobInfoDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        infoLabelStackView.topAnchor.constraint(equalTo: jobInfoDivider.bottomAnchor, constant: borderConstant).isActive = true
        infoLabelStackView.rightAnchor.constraint(equalTo: jobInfoView.rightAnchor, constant: -borderConstant).isActive = true
        infoLabelStackView.leftAnchor.constraint(equalTo: jobInfoView.leftAnchor, constant: borderConstant).isActive = true
        infoLabelStackView.bottomAnchor.constraint(equalTo: jobInfoView.bottomAnchor, constant: -borderConstant).isActive = true

        // Update Status Section
        updateStatusView.topAnchor.constraint(equalTo: jobInfoView.bottomAnchor, constant: borderConstant).isActive = true
        updateStatusView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -borderConstant).isActive = true
        updateStatusView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: borderConstant).isActive = true
        updateStatusView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -borderConstant).isActive = true
        
        updateStatusHeader.topAnchor.constraint(equalTo: updateStatusView.topAnchor, constant: borderConstant/2).isActive = true
        updateStatusHeader.centerXAnchor.constraint(equalTo: jobInfoView.centerXAnchor).isActive = true
        
        updateStatusDivider.topAnchor.constraint(equalTo: updateStatusHeader.bottomAnchor, constant: borderConstant/2).isActive = true
        updateStatusDivider.rightAnchor.constraint(equalTo: jobInfoView.rightAnchor, constant: -borderConstant).isActive = true
        updateStatusDivider.leftAnchor.constraint(equalTo: jobInfoView.leftAnchor, constant: borderConstant).isActive = true
        updateStatusDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true

        buttonStackView.topAnchor.constraint(equalTo: updateStatusDivider.bottomAnchor, constant: borderConstant).isActive = true
        buttonStackView.rightAnchor.constraint(equalTo: updateStatusView.rightAnchor, constant: -borderConstant).isActive = true
        buttonStackView.leftAnchor.constraint(equalTo: updateStatusView.leftAnchor, constant: borderConstant).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: updateStatusView.bottomAnchor, constant: -borderConstant).isActive = true
    }
    
    func configureStackView(arrangedSubViews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubViews)
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func configureStatusUpdateButton(titleLabel: String) -> UIButton {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setTitle(titleLabel, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(stageUpdateAction), for: .touchUpInside)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        return button
    }
    
    func configureJobInfoLabel(keyLabel: String, valueLabel: String) -> UILabel {
        let label = UILabel()
        label.text = "\(keyLabel):  \(valueLabel)"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.backgroundColor = .clear
        return label
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default
        navigationItem.title = "Job Status"
    }
    
    // MARK: - Selectors
    
    @objc func stageUpdateAction() {
        let updatedStage = jobRequest.currentStage + 1
        jobRequest.updateOnStageChange(toStage: updatedStage)
        
        reloadPageData()
        
        if (0...8).contains(updatedStage) {
            // stage update to JR must succeed write to jobsCompleted for stage=9
            jrf.updateOnStageChange(jobRequest: jobRequest)
        }
        if updatedStage == 7 {
            showFinalizeCostAlert()
        } else if updatedStage == 9 {
            didCompleteJob()
            showJobCompletionAlert()
        }
    }
    // MARK: - Helpers
    
    func reloadPageData() {
        let stageUpdateButtons: [Int: UIButton] = [
            2: stage2UpdateButton,
            3: stage3UpdateButton,
            4: stage4UpdateButton,
            5: stage5UpdateButton,
            6: stage6UpdateButton,
            7: stage7UpdateButton,
            8: stage8UpdateButton,
            9: stage9UpdateButton
        ]
        
        // jr.currentStage = 1 by the time it is assigned to dasher
        for i in 1...jobRequest.currentStage {
            guard let button = stageUpdateButtons[i] else {continue}
            button.isEnabled = false
            button.backgroundColor = .blue
        }
        
        guard let nextStageButton = stageUpdateButtons[jobRequest.currentStage+1] else {return}
        nextStageButton.isEnabled = true
        
        if jobRequest.wasCancelled {
            showJobCancellationAlert()
        }
        
    }
    
    func didCompleteJob() {
        jobRequest.udpateOnDasherCompletion(atTime: Timestamp(date: Date()))
        jrf.udpateOnDasherCompletion(jobRequest: jobRequest)
        jrf.writeCompletedJobOnDasherCompletion(jobRequest: jobRequest)
        jrf.updateOnStageChange(jobRequest: jobRequest)
        
        df.addCompletedJob(jobID: jobRequest.jobID, forDasherUID: jobRequest.dasherUID)
        
        delegate?.didComplete(jobRequest: jobRequest)
    }
    
    func addListenerToJobRequest(jobRequest: JobRequest) {
        let inProgressDocRef = Firestore.firestore().collection("jobsInProgress")
            .document(jobRequest.jobID)
        listener =
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
                    self.showJobCancellationAlert()
                }
        }
    }
    
    // MARK: - Alerts
    
    func showJobCancellationAlert() {
        let alert = UIAlertController(title: "Job Cancelled", message: "The customer has cancelled this request", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.delegate?.didComplete(jobRequest: self.jobRequest)
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true)
    }
    
    func showFinalizeCostAlert() {
        let alert = UIAlertController(title: "Update Cost Information", message: "Enter the total cost you paid, and the number of loads of laundry you did to complete the customer's laundry request", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Total cost incurred in $"
            textField.keyboardType = .numberPad
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Total number of loads of laundry"
        })
        
        alert.addAction(UIAlertAction(title: "Submit Information", style: .default, handler: { action in
            guard let machineCost = alert.textFields?[0].text,
                let numLoadsActual = alert.textFields?[1].text
                else {return}
            let mC = Double(machineCost)!
            let nLA = Int(numLoadsActual)!
            self.jobRequest.updateOnCostFinalized(machineCost: mC, numLoadsActual: nLA)
            self.jrf.updateOnCostFinalized(jobRequest: self.jobRequest)
        }))
        
        self.present(alert, animated: true)
    }
    
    func showJobCompletionAlert() {
        let alert = UIAlertController(title: "Job Complete", message: "You will receive $\(jobRequest.amountPaid!) for this job.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true)
    }
}
