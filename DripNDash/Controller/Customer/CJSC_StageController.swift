//
//  CJSC_StageController.swift
//  DripNDash
//
//  Created by Marty McCluskey on 3/12/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import UIKit

class CJSC_StageController: UIViewController {
/*
     Controller for stage view in CJSC Job Status portion. Format of view defined below based on stage in process
     - before
        - descriptionLabel
            .text = step[0].text
            .color = .darkGray
        - indicatorLabel
            .color = .darkGray
     - during
        - descriptionLabel
            .text = step[0].text
            .color = .black
        - indicatorLabel
            .color = .blue
     - after
        - descriptionLabel
            .text = step[1].text
            .color = .black
        - indicatorLabel
            .color = .green
*/
    
    // MARK: - Properties
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let indicatorLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpAutoLayout()
    }
    
    // MARK: - Config
    
    func configureUI() {
        view.addSubview(descriptionLabel)
        view.addSubview(indicatorLabel)
        
        view.backgroundColor = .clear
    }
    
    func setUpAutoLayout() {
        indicatorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicatorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        indicatorLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        indicatorLabel.widthAnchor.constraint(equalToConstant: 15).isActive = true
        
        descriptionLabel.leftAnchor.constraint(equalTo: indicatorLabel.rightAnchor, constant: 20).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // MARK: - Interface
    
    func setProperties(descriptionText: String, subStageIndex: Int) {
    /*
         descriptionText -> value representing the description of the stage
         subStageIndex -> [0: "before stage", 1: "during stage", 2: "after stage"]
    */
        descriptionLabel.text = descriptionText
        switch subStageIndex {
        case 0:
            descriptionLabel.textColor = .darkGray
            indicatorLabel.backgroundColor = .darkGray
            break
        case 1:
            descriptionLabel.textColor = .black
            indicatorLabel.backgroundColor = .blue
            break
        case 2:
            descriptionLabel.textColor = .black
            indicatorLabel.backgroundColor = .green
            break
        default:
            break
        }
        
    }
}
