//
//  Dasher.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/20/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import Firebase

struct Dasher {
    
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    let dorm: String
    let dormRoom: Int
    let rating: Int
    let numCompletedJobs: Int
    let registerTimestamp: Timestamp
    
    var completedJobs: [String]
}
