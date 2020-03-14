//
//  JobRequest.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/19/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

/* TODO: define requirements for info needed for full status page
 Requirements for show dasher Profile:
 - Attributes: Name, Rating, Reviews, Photo,
 s
*/

import Firebase

class JobRequest {
    
    // MARK: - Init Properties
    
    let jobID: String
    let requestTimestamp: Timestamp
    let numLoads: Int
    let dorm: String
    let dormRoom: Int
    
    // MARK: - Properties Assigned on Dasher_Accept
    
    var dasherUID: String!
    var assignedTimestamp: Timestamp!
    
    // MARK: - Dynamic Properties (updated by dasher throughout job)
    
    var currentStage: Int = 0     // stage in the process of laundry job, starts @ stage 0
    
    // MARK: - Properties Assigned on Job_Completion
    
    var completedTimestamp: Timestamp!
    
    // MARK: - Static Properties
    
    let stages: [Int: String] = [
    /*
       During Stage -> After Stage Complete
    */
        0: "Waiting for Dasher to Accept", 1: "Dasher Accepted Request",
        2: "Dasher on Way for Pickup", 3: "Picked up Laundry",
        4: "Laundry in Washer", 5: "Finished Washing",
        6: "Laundry in Dryer", 7: "Finished Drying",
        8: "Dasher On Way for Drop Off", 9: "Dropped off Laundry"
    ]

    // MARK: - Interface/Computed Properties
    
    var currentStatus: String {
        return stages[currentStage] ?? "Current Status Unavailable"
    }
    
    func updateOnAssignment(toDasher dasher: Dasher, atTime time: Timestamp) {
        dasherUID = dasher.uid
        assignedTimestamp = time
        currentStage = 1
    }
    
    // MARK: - Init
    
    init(jobID: String, requestTimestamp: Timestamp, dorm: String, dormRoom: Int, numLoads: Int) {
        self.jobID = jobID
        self.requestTimestamp = requestTimestamp
        self.dorm = dorm
        self.dormRoom = dormRoom
        self.numLoads = numLoads
    }
}
