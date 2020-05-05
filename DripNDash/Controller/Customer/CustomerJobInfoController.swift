//
//  CustomerJobInfoController.swift
//  DripNDash
//
//  Created by Liam McCluskey on 3/26/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

// written by: Liam McCluskey
// tested by: Liam McCluskey
// debugged by: Liam McCluskey

import UIKit

class CustomerJobInfoController: UIViewController {
    
    // MARK: - Properties
    
    let completedJob: JobRequest!
    
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
        label.text = "Request Information"
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
    var dateLabel: UILabel!
    var dasherNameLabel: UILabel!
    var customerRatingLabel: UILabel!
    var customerReviewLabel: UILabel!
    var estimatedNumLoadsLabel: UILabel!
    var instructionsLabel: UILabel!
    
    let receiptView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.init(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let receiptHeader: UILabel = {
        let label = UILabel()
        label.text = "Receipt"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let receiptDivider: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var receiptStackView: UIStackView!
    var actualNumLoadsLabel: UILabel!
    var actualCostLabel: UILabel!

    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpAutoLayout()
    }
    
    init(completedJob: JobRequest) {
        self.completedJob = completedJob
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Config
    
    private func configureUI() {
        
        configureNavigationBar()
        
        // Job Info Portion
        dateLabel = configureInfoLabel(keyLabel: "Date", valueLabel: completedJob.getDateTime())
        dasherNameLabel = configureInfoLabel(keyLabel: "Dasher Name", valueLabel: completedJob.dasherName)
        customerRatingLabel = configureInfoLabel(keyLabel: "Rating You Left", valueLabel: String(completedJob.customerRatingContext))
        customerReviewLabel = configureInfoLabel(keyLabel: "Review You Left", valueLabel: completedJob.customerReview)
        estimatedNumLoadsLabel = configureInfoLabel(keyLabel: "Estimated Number of Loads", valueLabel: String(completedJob.numLoadsEstimate))
        instructionsLabel = configureInfoLabel(keyLabel: "Your Instructions", valueLabel: completedJob.customerInstructions)
        jobInfoStackView = configureStackView(arrangedSubViews: [
            dateLabel,
            dasherNameLabel,
            customerRatingLabel,
            customerReviewLabel,
            estimatedNumLoadsLabel,
            instructionsLabel,
            ])
        jobInfoView.addSubview(jobInfoHeader)
        jobInfoView.addSubview(jobInfoDivider)
        jobInfoView.addSubview(jobInfoStackView)
        view.addSubview(jobInfoView)
        
        // Receipt Portion
        actualNumLoadsLabel = configureInfoLabel(keyLabel: "Actual Number of Loads", valueLabel: String(completedJob.numLoadsActual))
        actualCostLabel = configureInfoLabel(keyLabel: "Total Cost ($)", valueLabel: String(completedJob.amountPaid))
        receiptStackView = configureStackView(arrangedSubViews: [actualNumLoadsLabel, actualCostLabel])
        receiptView.addSubview(receiptHeader)
        receiptView.addSubview(receiptDivider)
        receiptView.addSubview(receiptStackView)
        view.addSubview(receiptView)
        
        view.backgroundColor = .white
        title = "Request Details"
    }
    
    private func setUpAutoLayout() {
        let border: CGFloat = 10
        
        // Job Info Portion
        jobInfoView.topAnchor.constraint(equalTo: view.topAnchor, constant: border).isActive = true
        jobInfoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -border).isActive = true
        jobInfoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: border).isActive = true
        jobInfoView.heightAnchor.constraint(equalToConstant: view.frame.height/1.6).isActive = true
        
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
        
        //Receipt Portion
        receiptView.topAnchor.constraint(equalTo: jobInfoView.bottomAnchor, constant: border).isActive = true
        receiptView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -border).isActive = true
        receiptView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: border).isActive = true
        receiptView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -border).isActive = true
        
        receiptHeader.topAnchor.constraint(equalTo: receiptView.topAnchor, constant: border/2).isActive = true
        receiptHeader.centerXAnchor.constraint(equalTo: receiptView.centerXAnchor).isActive = true
        
        receiptDivider.topAnchor.constraint(equalTo: receiptHeader.bottomAnchor, constant: border/2).isActive = true
        receiptDivider.rightAnchor.constraint(equalTo: receiptView.rightAnchor, constant: -border).isActive = true
        receiptDivider.leftAnchor.constraint(equalTo: receiptView.leftAnchor, constant: border).isActive = true
        receiptDivider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        receiptStackView.topAnchor.constraint(equalTo: receiptDivider.bottomAnchor, constant: border).isActive = true
        receiptStackView.rightAnchor.constraint(equalTo: receiptView.rightAnchor, constant: -border).isActive = true
        receiptStackView.leftAnchor.constraint(equalTo: receiptView.leftAnchor, constant: border).isActive = true
        receiptStackView.bottomAnchor.constraint(equalTo: receiptView.bottomAnchor, constant: -border).isActive = true
        
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .default
        navigationItem.title = "Request Details"
    }

    
    private func configureStackView(arrangedSubViews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubViews)
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func configureInfoLabel(keyLabel: String, valueLabel: String) -> UILabel {
        let label = UILabel()
        label.text = "\(keyLabel):  \(valueLabel)"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.backgroundColor = .clear
        return label
    }
    
}
