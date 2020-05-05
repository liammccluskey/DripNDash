//
//  Protocols.swift
//  DripNDash
//
//  Created by Liam McCluskey on 2/14/20.
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
    func sendRequestsPendingAccept(jobIDs: [String])
}

protocol JobRequestFirestoreDelegate {
    func sendJobRequest(jobRequest: JobRequest)
    //func sendUpdatedJobRequest(jobRequest: JobRequest)
    func sendCompletedJobs(jobRequests: [JobRequest])
    func sendAcceptedJobRequest(jobRequest: JobRequest)
}

protocol DasherJobNotificationDelegate {
    func didReject(jobRequest: JobRequest)
    func didAccept(jobRequest: JobRequest)
}

protocol DasherJobStatusControllerDelegate {
/*
     Conforms:
     - DasherHomeController: Tells DasherJobsTableController to remove a JR obj
*/
    func didComplete(jobRequest: JobRequest)
    func didUpdate(jobRequest: JobRequest)
}

protocol CustomerJobStatusControllerDelegate {
/*
     Conforms:
     - CustomerHomeController: Tells CustomerJobsTableController to remove a JR obj
*/
    func didCancel(jobRequest: JobRequest)
    func didComplete(jobRequest: JobRequest)
}

protocol JobHistoryTableControllerDelegate {
/*
     Conforms:
     - CustomerJobHistoryController
     - DasherJobHistoryController
*/
    func didSelectJob(jobRequest: JobRequest)
}




