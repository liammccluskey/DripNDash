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
    let customerUID: String
    let requestTimestamp: Timestamp
    let numLoadsEstimate: Int
    let dorm: String
    let dormRoom: Int
    let customerName: String
    let customerInstructions: String
    var wasCancelled: Bool = false
    
    // MARK: - Properties Assigned on Dasher_Accept
    
    var dasherUID: String!
    var assignedTimestamp: Timestamp!
    var dasherName: String!
    var dasherRating: Double!
    
    // MARK: - Dynamic Properties (updated by dasher throughout job)
    
    var currentStage: Int   // stage in the process of laundry job, starts @ stage 0
    
    // MARK: - Properties assigned by dasher after stage=7 (finished drying)
    
    var machineCost: Double!
    var numLoadsActual: Int!
    var amountPaid: Double!
    
    // MARK: - Properties assigned value after job completion
    
    var completedTimestamp: Timestamp!
    var customerRating: Double!
    var customerReview: String!
    
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
    
    func updateOnCustomerCancel() {
        self.wasCancelled = true
    }
    
    func updateOnAssignment(toDasher dasher: Dasher, atTime time: Timestamp) {
    /*
         Caller: DasherHomeActivity ON(use clicks assign job button and job is assigned to a dasher)
    */
        dasherUID = dasher.uid
        dasherName = "\(dasher.firstName) \(dasher.lastName)"
        dasherRating = dasher.rating
        assignedTimestamp = time
        currentStage = 1
    }
    
    func updateOnStageChange(toStage stage: Int) {
        currentStage = stage
    }
    
    func updateOnCostFinalized(machineCost: Double, numLoadsActual: Int) {
    /*
         Caller: DasherJobStatusActivity ON(user clicks stage7updatebutton and enters finalized cost details
    */
        self.machineCost = machineCost
        self.numLoadsActual = numLoadsActual
        self.amountPaid = self.estimatedTotalCost(forNumLoads: numLoadsActual)
    }
    
    func udpateOnDasherCompletion(atTime time: Timestamp) {
    /*
         Caller: DasherJobStatusActivity ON(user clicks stage9updatebutton)
    */
        self.completedTimestamp = time
    }
    
    func updateOnCustomerReview(customerRating: Double, customerReview: String) {
        self.customerRating = customerRating
        self.customerReview = customerReview
    }
    
    // MARK: - Init
    
    init(jobID: String, customerUID: String, requestTimestamp: Timestamp, numLoadsEstimate: Int, dorm: String, dormRoom: Int, customerName: String, customerInstructions: String) {
    /*
         Caller: CustomerHomeController ON(user clicks submit request button)
    */
        self.jobID = jobID
        self.customerUID = customerUID
        self.requestTimestamp = requestTimestamp
        self.numLoadsEstimate = numLoadsEstimate
        self.dorm = dorm
        self.dormRoom = dormRoom
        self.customerName = customerName
        self.customerInstructions = customerInstructions
        
        self.currentStage = 0
        
        self.wasCancelled = false
    }
    
    init(fromDocData docData: [String: Any]) {
    /*
         Caller: JobRequestFirestore.getInProgressJobRequest ON(method is called to assign a dasher a job request)
    */
        self.jobID = docData["JOB_ID"] as! String
        self.customerUID = docData["CUSTOMER_UID"] as! String
        self.requestTimestamp = docData["REQUEST_TIMESTAMP"] as! Timestamp
        self.numLoadsEstimate = docData["NUM_LOADS_ESTIMATE"] as! Int
        self.dorm = docData["DORM"] as! String
        self.dormRoom = docData["DORM_ROOM"] as! Int
        self.customerName = docData["CUSTOMER_NAME"] as! String
        self.customerInstructions = docData["CUSTOMER_INSTRUCTIONS"] as! String
        
        self.currentStage = docData["CURRENT_STAGE"] as! Int
        
        self.assignedTimestamp = docData["ASSIGNED_TIMESTAMP"] as? Timestamp ?? Timestamp(date: Date())
        self.dasherUID = docData["DASHER_UID"] as? String ?? ""
        self.dasherName = docData["DASHER_NAME"] as? String ?? ""
        self.dasherRating = docData["DASHER_RATING"] as? Double ?? -1
        
        self.machineCost = docData["MACHINE_COST"] as? Double ?? -1
        self.numLoadsActual = docData["NUM_LOADS_ACTUAL"] as? Int ?? -1
        self.amountPaid = docData["AMOUNT_PAID"] as? Double ?? -1
        
        self.completedTimestamp = docData["COMPLETED_TIMESTAMP"] as? Timestamp ?? Timestamp(date: Date())
        
        self.wasCancelled = docData["WAS_CANCELLED"] as! Bool
        
        // only relevant to JR objs in jobsCompleted collection
        self.customerRating = docData["CUSTOMER_RATING"] as? Double ?? -1
        self.customerReview = docData["CUSTOMER_REVIEW"] as? String ?? ""
    }
    
    // MARK: Interface
    
    func toJobsInProgressData() -> [String: Any] {
    /*
         Caller: JRF.writeJobREquest() on initial write
    */
        let data: [String: Any] = [
            "JOB_ID": self.jobID,
            "CUSTOMER_UID": self.customerUID,
            "REQUEST_TIMESTAMP": self.requestTimestamp,
            "DORM": self.dorm,
            "DORM_ROOM": self.dormRoom,
            "NUM_LOADS_ESTIMATE": self.numLoadsEstimate,
            "CUSTOMER_INSTRUCTIONS": self.customerInstructions,
            "CUSTOMER_NAME": self.customerName,
            "CURRENT_STAGE": self.currentStage,
            "ASSIGNED_TIMESTAMP": "",
            "DASHER_UID": "",
            "DASHER_NAME" : "",
            "DASHER_RATING": -1,
            "MACHINE_COST": -1,
            "AMOUNT_PAID": -1,
            "NUM_LOADS_ACTUAL": -1,
            "COMPLETED_TIMESTAMP": "",
            "WAS_CANCELLED": self.wasCancelled
        ]
        return data
    }
    
    func toJobsCompletedData() -> [String: Any] {
    /*
         Caller: JRF.writeCompletedJobOnDasherCompletion()
    */
        let data: [String: Any] = [
            "JOB_ID": self.jobID,
            "CUSTOMER_UID": self.customerUID,
            "REQUEST_TIMESTAMP": self.requestTimestamp,
            "DORM": self.dorm,
            "DORM_ROOM": self.dormRoom,
            "NUM_LOADS_ESTIMATE": self.numLoadsEstimate,
            "CUSTOMER_INSTRUCTIONS": self.customerInstructions,
            "CUSTOMER_NAME": self.customerName,
            "ASSIGNED_TIMESTAMP": self.assignedTimestamp,
            "DASHER_UID": self.dasherUID,
            "DASHER_NAME" : self.dasherName,
            "DASHER_RATING": self.dasherRating,
            "MACHINE_COST": self.machineCost,
            "AMOUNT_PAID": self.amountPaid,
            "NUM_LOADS_ACTUAL": self.numLoadsActual,
            "COMPLETED_TIMESTAMP": self.completedTimestamp,
            "CUSTOMER_RATING": "",
            "CUSTOMER_REVIEW": "",
        ]
        return data
    }
    
    // MARK: - Helper
    
    func estimatedTotalCost(forNumLoads numLoads: Int) -> Double {
        return Double(numLoads)*1.50*2.0 + 5.0 + 2.0
    }
}

