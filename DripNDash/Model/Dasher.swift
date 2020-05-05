//
//  Dasher.swift
//  DripNDash
//
//  Created by Liam McCluskey on 2/20/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

// written by: Liam McCluskey
// tested by: Liam McCluskey
// debugged by: Liam McCluskey

import Firebase

struct Dasher {
    
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    let dorm: String
    let dormRoom: Int
    let rating: Double
    let numCompletedJobs: Int
    let registerTimestamp: Timestamp
    
    var completedJobs: [String]
    
    init(uid: String, firstName: String, lastName: String, email: String, dorm: String, dormRoom: Int) {
    /*
         Caller: DasherRegisterController ON(user submits registration information)
    */
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.dorm = dorm
        self.dormRoom = dormRoom
        rating = 5
        numCompletedJobs = 0
        registerTimestamp = Timestamp(date: Date())
        completedJobs = []
    }
    
    init(fromDocData docData: [String: Any]) {
        uid = docData["UID"] as! String
        firstName = docData["FIRST_NAME"] as! String
        lastName = docData["LAST_NAME"] as! String
        email = docData["EMAIL"] as! String
        dorm = docData["DORM"] as! String
        dormRoom = docData["DORM_ROOM"] as! Int
        rating = docData["RATING"] as! Double
        numCompletedJobs = docData["NUM_COMPLETED_JOBS"] as! Int
        registerTimestamp = docData["REGISTER_TIMESTAMP"] as! Timestamp
        completedJobs = docData["COMPLETED_JOBS"] as! [String]
    }
    
}
