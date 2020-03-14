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
    var listener: ListenerRegistration!
    let db = Firestore.firestore()
    
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
        view.addSubview(statusStackView)
        
        view.backgroundColor = .white
        title = "Laundry Request Status"
    }
    
    func setUpAutoLayout(){
        let border: CGFloat = 10
        
        statusStackView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        statusStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -border).isActive = true
        statusStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: border).isActive = true
        statusStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -border).isActive = true
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
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    // MARK: - Selectors
    
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
        }
    }
    
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
}
