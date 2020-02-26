//
//  JobRequest.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/19/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import Firebase

class JobRequest {
    
    // MARK: - Init Properties
    
    let jobID: String
    let requestTimestamp: Timestamp
    let numLoads: Int
    
    // MARK: - Properties Assigned on Dasher_Accept
    
    var dasherUID: String!
    var assignedTimestamp: Timestamp!
    
    // MARK: - Dynamic Properties (updated by dasher throughout job)
    
    var currentStage: Int = 0     // stage in the process of laundry job, starts @ stage 0
    
    // MARK: - Properties Assigned on Job_Completion
    
    var completedTimestamp: Timestamp!
    
    // MARK: - Static Properties
    let stages: [Int: String] = [
        0: "Waiting for Dasher to Accept",
        1: "Dasher on Way",
        2: "Dasher Outside for Pickup",
        3: "Waiting for Washer",
        4: "Laundry in Washer",
        5: "Waiting for Dryer",
        6: "Laundry in Dryer",
        7: "Completed, Dasher on Way",
        8: "Dasher Outside for Dropoff"
    ]

    // MARK: - Interface/Computed Properties
    
    var currentStatus: String {
        return stages[currentStage] ?? "Current Status Unavailable"
    }
    
    // MARK: - Init
    
    init(jobID: String, requestTimestamp: Timestamp, numLoads: Int) {
        self.jobID = jobID
        self.requestTimestamp = requestTimestamp
        self.numLoads = numLoads
    }
}
