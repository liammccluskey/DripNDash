//
//  CustomerJobStatusController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/16/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit
import Firebase

class CustomerJobStatusController: UIViewController {
    
    // MARK: - Properties
    
    var jobRequest: JobRequest!
    let jrf = JobRequestFirestore()
    var listener: ListenerRegistration!
    let db = Firestore.firestore()
    
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
    
    var jobInfoStackView: UIStackView!
    var dasherNameLabel: UILabel!
    var dasherRatingLabel: UILabel!
    var estimatedCostLabel: UILabel!
    var estimatedNumLoadsLabel: UILabel!
    var instructionsLabel: UILabel!
    
    let jobStatusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let jobStatusHeader: UILabel = {
        let label = UILabel()
        label.text = "Job Status"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobStatusDivider: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let embeddedJobStatusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var statusStackView: UIStackView!
  
    var stage01b: UIView!
    var stage01d: UIView!
    var stage01a: UIView!
    
    var stage23b: UIView!
    var stage23d: UIView!
    var stage23a: UIView!
    
    var stage45b: UIView!
    var stage45d: UIView!
    var stage45a: UIView!
    
    var stage67b: UIView!
    var stage67d: UIView!
    var stage67a: UIView!

    var stage89b: UIView!
    var stage89d: UIView!
    var stage89a: UIView!
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("Cancel Request", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addListenerToJobRequest(jobRequest: jobRequest)
        
        configureUI()
        setUpAutoLayout()
        
        reloadStatusStackView()
    }
    
    init(jobRequest: JobRequest) {
        self.jobRequest = jobRequest
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Config
    
    func configureUI(){
        // Job Information Portion
        dasherNameLabel = configureJobInfoLabel(keyLabel: "Dasher Name", valueLabel: jobRequest.dasherName)
        dasherRatingLabel = configureJobInfoLabel(keyLabel: "Dasher Rating", valueLabel: String(jobRequest.dasherRating))
        estimatedCostLabel = configureJobInfoLabel(keyLabel: "Estimated Cost ($)", valueLabel: String(jobRequest.estimatedTotalCost(forNumLoads: jobRequest.numLoadsEstimate)))
        estimatedNumLoadsLabel = configureJobInfoLabel(keyLabel: "Estimated Number of Loads", valueLabel: String(jobRequest.numLoadsEstimate))
        instructionsLabel = configureJobInfoLabel(keyLabel: "Your Instructions", valueLabel: jobRequest.customerInstructions)
        jobInfoStackView = configureStackView(arrangedSubViews: [
            dasherNameLabel,
            dasherRatingLabel,
            estimatedCostLabel,
            estimatedNumLoadsLabel,
            instructionsLabel
            ])
        
        jobInfoView.addSubview(jobInfoHeader)
        jobInfoView.addSubview(jobInfoDivider)
        jobInfoView.addSubview(jobInfoStackView)
        view.addSubview(jobInfoView)
        
        // Job Status Portion
        stage01b = configureStageView(stageIndex: 0, subStageIndex: 0)
        stage01d = configureStageView(stageIndex: 0, subStageIndex: 1)
        stage01a = configureStageView(stageIndex: 1, subStageIndex: 2)
        
        stage23b = configureStageView(stageIndex: 2, subStageIndex: 0)
        stage23d = configureStageView(stageIndex: 2, subStageIndex: 1)
        stage23a = configureStageView(stageIndex: 3, subStageIndex: 2)
        
        stage45b = configureStageView(stageIndex: 4, subStageIndex: 0)
        stage45d = configureStageView(stageIndex: 4, subStageIndex: 1)
        stage45a = configureStageView(stageIndex: 5, subStageIndex: 2)
        
        stage67b = configureStageView(stageIndex: 6, subStageIndex: 0)
        stage67d = configureStageView(stageIndex: 6, subStageIndex: 1)
        stage67a = configureStageView(stageIndex: 7, subStageIndex: 2)
        
        stage89b = configureStageView(stageIndex: 8, subStageIndex: 0)
        stage89d = configureStageView(stageIndex: 8, subStageIndex: 1)
        stage89a = configureStageView(stageIndex: 9, subStageIndex: 2)
        
        statusStackView = configureStackView(arrangedSubViews: [stage01b, stage23b, stage45b, stage67b, stage89b])
        
        embeddedJobStatusView.addSubview(statusStackView)
        
        jobStatusView.addSubview(jobStatusHeader)
        jobStatusView.addSubview(jobStatusDivider)
        jobStatusView.addSubview(embeddedJobStatusView)
        view.addSubview(jobStatusView)
        
        view.addSubview(cancelButton)
        
        view.backgroundColor = .white
        title = "Laundry Request Status"
    }
    
    func setUpAutoLayout(){
        let border: CGFloat = 10
        
        // global anchor points
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        // Job Information Portion
        jobInfoView.topAnchor.constraint(equalTo: view.topAnchor, constant: border).isActive = true
        jobInfoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -border).isActive = true
        jobInfoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: border).isActive = true
        jobInfoView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        
        jobInfoHeader.topAnchor.constraint(equalTo: jobInfoView.topAnchor, constant: border/2).isActive = true
        jobInfoHeader.centerXAnchor.constraint(equalTo: jobInfoView.centerXAnchor).isActive = true
        
        jobInfoDivider.topAnchor.constraint(equalTo: jobInfoHeader.bottomAnchor, constant: border/2).isActive = true
        jobInfoDivider.rightAnchor.constraint(equalTo: jobInfoView.rightAnchor, constant: -border).isActive = true
        jobInfoDivider.leftAnchor.constraint(equalTo: jobInfoView.leftAnchor, constant: border).isActive = true
        jobInfoDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        jobInfoStackView.topAnchor.constraint(equalTo: jobInfoDivider.bottomAnchor, constant: border).isActive = true
        jobInfoStackView.rightAnchor.constraint(equalTo: jobInfoView.rightAnchor, constant: -border).isActive = true
        jobInfoStackView.leftAnchor.constraint(equalTo: jobInfoView.leftAnchor, constant: border).isActive = true
        jobInfoStackView.bottomAnchor.constraint(equalTo: jobInfoView.bottomAnchor, constant: -border).isActive = true
        
        // JOb Status portion
        jobStatusView.topAnchor.constraint(equalTo: jobInfoView.bottomAnchor, constant: border).isActive = true
        jobStatusView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -border).isActive = true
        jobStatusView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: border).isActive = true
        jobStatusView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -border).isActive = true
        
        jobStatusHeader.topAnchor.constraint(equalTo: jobStatusView.topAnchor, constant: border/2).isActive = true
        jobStatusHeader.centerXAnchor.constraint(equalTo: jobInfoView.centerXAnchor).isActive = true
        
        jobStatusDivider.topAnchor.constraint(equalTo: jobStatusHeader.bottomAnchor, constant: border/2).isActive = true
        jobStatusDivider.rightAnchor.constraint(equalTo: jobInfoView.rightAnchor, constant: -border).isActive = true
        jobStatusDivider.leftAnchor.constraint(equalTo: jobInfoView.leftAnchor, constant: border).isActive = true
        jobStatusDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        embeddedJobStatusView.topAnchor.constraint(equalTo: jobStatusDivider.bottomAnchor, constant: border).isActive = true
        embeddedJobStatusView.rightAnchor.constraint(equalTo: jobStatusView.rightAnchor, constant: -border).isActive = true
        embeddedJobStatusView.leftAnchor.constraint(equalTo: jobStatusView.leftAnchor, constant: border).isActive = true
        embeddedJobStatusView.bottomAnchor.constraint(equalTo: jobStatusView.bottomAnchor, constant: -border).isActive = true
        
        statusStackView.topAnchor.constraint(equalTo: embeddedJobStatusView.topAnchor, constant: 3*border).isActive = true
        statusStackView.rightAnchor.constraint(equalTo: embeddedJobStatusView.rightAnchor, constant: -border).isActive = true
        statusStackView.leftAnchor.constraint(equalTo: embeddedJobStatusView.leftAnchor, constant: border).isActive = true
        statusStackView.bottomAnchor.constraint(equalTo: embeddedJobStatusView.bottomAnchor, constant: -3*border).isActive = true
        
    }
    
    func configureStageView(stageIndex: Int, subStageIndex: Int) -> UIView {
        let stageController = CJSC_StageController()
        let descriptionText = jobRequest.stages[stageIndex]
        stageController.setProperties(descriptionText: descriptionText!, subStageIndex: subStageIndex)
        return stageController.view
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
    
    func configureJobInfoLabel(keyLabel: String, valueLabel: String) -> UILabel {
        let label = UILabel()
        label.text = "\(keyLabel):  \(valueLabel)"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.backgroundColor = .clear
        //label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // MARK: - Selectors
    
    @objc func cancelAction() {
        if jobRequest.currentStage <= 2 {
            showConfirmCancelAlert()
        } else {
            showCannotCancelAlert()
        }
    }
    
    // MARK: - Helpers
    
    func addListenerToJobRequest(jobRequest: JobRequest) {
        let inProgressDocRef = db.collection("jobsInProgress")
            .document(jobRequest.jobID)
        listener =
            inProgressDocRef.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("CJSC.addListenerToJobRequest() Error: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("CJSC.addListenerToJobRequest() Error: Document was empty)")
                    return
                }
                jobRequest.currentStage = data["CURRENT_STAGE"] as? Int ?? 0
                self.updateStatusStackView(atStage: jobRequest.currentStage)
                self.reloadJobInfoStackView()
        }
    }
    
    
    
    func showConfirmCancelAlert() {
        let alert = UIAlertController(title: "Cancel This Request", message: "Are you sure you want to cancel this request?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No, don't cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes, cancel it", style: .default, handler: { (action) in
            self.jobRequest.updateOnCustomerCancel()
            self.jrf.updateOnCustomerCancel(jobRequest: self.jobRequest)
            // notify tableController to remove this entry
            // set dasher side listener to detect cancellation
            
        }))
        present(alert, animated: true)
    }
    
    func showCannotCancelAlert() {
        let alert = UIAlertController(title: "Cannot Cancel Request", message: "Since a dasher has already picked up your laundry, your request is in progress and cannot be cancelled.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel Request", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Reload Page data
    
    func updateStatusStackView(atStage stage: Int) {
        let step: Int = stage/2
        let subStage: String = stage % 2 == 0 ? "during" : "after"
        
        let stageViews: [Int: [String: UIView]] = [
            0: [
                "during": stage01d,
                "after": stage01a
            ],
            1: [
                "during": stage23d,
                "after": stage23a
            ],
            2: [
                "during": stage45d,
                "after": stage45a
            ],
            3: [
                "during": stage67d,
                "after": stage67a
            ],
            4: [
                "during": stage89d,
                "after": stage89a
            ],
            ]
        
        let currentStageView = statusStackView.arrangedSubviews[step]
        let newStageView = stageViews[step]![subStage]!
        currentStageView.removeFromSuperview()
        statusStackView.insertArrangedSubview(newStageView, at: step)
        
        print("Updated for Step: \(step)")
        print("Updated for SubStage: \(subStage)")
    }
    
    func reloadStatusStackView() {
        for i in 0...jobRequest.currentStage {
            updateStatusStackView(atStage: i)
        }
    }
    
    func reloadJobInfoStackView() {
        dasherRatingLabel.text? = "Dasher Rating: \(jobRequest.dasherRating!)"
        dasherNameLabel.text? = "Dasher Name: \(jobRequest.dasherName!)"
    }
    
    
}
