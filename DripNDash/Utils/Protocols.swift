//
//  Protocols.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/14/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

protocol SignInControllerDelegate {
    func userDidSignIn(userClass: String)
}

protocol CustomerJobsTableControllerDelegate {
    func didSelectJob(jobRequest: JobRequest)
}

protocol DasherJobsTableControllerDelegate {
    func didSelectJob(jobRequest: JobRequest)
}

protocol CustomerFirestoreDelegate {
    func sendCustomer(customer: Customer?)
}

protocol DasherFirestoreDelegate {
    func sendDasher(dasher: Dasher?)
}

protocol JobRequestFirestoreDelegate {
    func sendJobRequest(jobRequest: JobRequest)
    func sendUpdatedJobRequest(jobRequest: JobRequest)
}

protocol DasherJobNotificationDelegate {
    func didReject(jobRequest: JobRequest)
    func didAccept(jobRequest: JobRequest)
}

protocol DasherJobStatusControllerDelegate {
    /*
     Cache Management: Local update must update Main memory (analogy)
    */
    func didUpdateJobRequest(jobRequest: JobRequest)
}

