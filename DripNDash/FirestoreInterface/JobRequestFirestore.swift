//
//  JobRequestFirestore.swift
//  DripNDash
//
//  Created by Liam McCluskey on 2/24/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

// written by: Liam McCluskey
// tested by: Liam McCluskey
// debugged by: Liam McCluskey

import Firebase

class JobRequestFirestore {
    
    // MARK: Properties
    
    var delegate: JobRequestFirestoreDelegate?
    
    let db = Firestore.firestore()
    
    // MARK: - Job Submission / Resubmission

    func writeJobRequest(jobRequest: JobRequest, isRewrite: Bool) {
    /*
        Writes the customer's job request to Firestore, or rewrites only to jobsPendingAssignment collection if isRewrite = true
    */
        // create pendingDoc
        let pendingDocData: [String: Any] = [
            "REQUEST_TIMESTAMP": jobRequest.requestTimestamp,
            ]
        let pendingDocRef = db.collection("dorms")
            .document(jobRequest.dorm)
            .collection("jobsPendingAssignment")
            .document(jobRequest.jobID)
        
        // create inProgressDoc
        let inProgressDocData = jobRequest.toJobsInProgressData()
        let inProgressDocRef = db.collection("jobsInProgress")
            .document(jobRequest.jobID)
        
        // batchWrite tempDoc @ pendingADDRESS and mainDoc @ inProgressADDRESS
        let batch = db.batch()
        batch.setData(pendingDocData, forDocument: pendingDocRef)
        if !isRewrite {
            batch.setData(inProgressDocData, forDocument: inProgressDocRef)
        }
        batch.commit { (error) in
            if let error = error {
                print("Error occured submitting job request: \(error)")
                // TODO: HANDLE_ERROR
            }
        }
    }
    
    
    func writeJobRequest(jobRequest: JobRequest, availableToDasherUID uid: String) {
        /*
         Writes the customer's job request only to JIP collection and notfies dasher collection of specific request
         */
        
        let inProgressDocData = jobRequest.toJobsInProgressData()
        let inProgressDocRef = db.collection("jobsInProgress")
            .document(jobRequest.jobID)
        
        let dasherRef = db.collection("dashers")
            .document(uid)
        
        let batch = db.batch()
        batch.setData(inProgressDocData, forDocument: inProgressDocRef)
        batch.updateData(["REQUESTS_PENDING_ACCEPT": FieldValue.arrayUnion([jobRequest.jobID])], forDocument: dasherRef)
        batch.commit { (error) in
            if let error = error {
                print("Error occured submitting job request: \(error)")
                // TODO: HANDLE_ERROR
            }
        }
        
    }
    
    func deleteJobRequest(jobRequest: JobRequest) {
    /*
         Caller: DasherJobsTableController ON(listener detects "WAS_CANCELLED" = true)
         Caller: CustomerJobStatusController ON(customer submits review and JR finalized)
    */
        let pendingDocRef = db.collection("dorms")
            .document(jobRequest.dorm)
            .collection("jobsPendingAssignment")
            .document(jobRequest.jobID)
        let inProgressDocRef = db.collection("jobsInProgress")
            .document(jobRequest.jobID)
        
        pendingDocRef.delete { (error) in
            guard let error = error else {return}
            print("JRF.deleteJobRequest() Error deleting @JPAaddress: \(error)")
        }
        inProgressDocRef.delete { (error) in
            guard let error = error else {return}
            print("JRF.deleteJobRequest() Error deleting @ IPJaddress: \(error)")

        }
    }
    
    func updateOnCustomerCancel(jobRequest: JobRequest) {
    /*
         Caller: CustomerJobStatusController ON(user clicks cancel job reqeust)
    */
        let fields: [AnyHashable: Any] = [
            "WAS_CANCELLED": jobRequest.wasCancelled
        ]
        updateJobRequest(jobRequest: jobRequest, fields: fields)
    }
    
    // MARK: - Updates to Job Request while in progress
    
    func updateOnAssignmentAccept(jobRequest: JobRequest) {
        let fields: [AnyHashable: Any] = [
            "DASHER_UID": jobRequest.dasherUID,
            "DASHER_NAME": jobRequest.dasherName,
            "DASHER_RATING": jobRequest.dasherRating,
            "ASSIGNED_TIMESTAMP": jobRequest.assignedTimestamp,
            "CURRENT_STAGE": jobRequest.currentStage
        ]
        updateJobRequest(jobRequest: jobRequest, fields: fields)
    }
    
    func updateOnStageChange(jobRequest: JobRequest) {
        let fields: [AnyHashable: Any] = [
            "CURRENT_STAGE": jobRequest.currentStage
        ]
        updateJobRequest(jobRequest: jobRequest, fields: fields)
    }
    
    func updateOnCostFinalized(jobRequest: JobRequest) {
        let fields: [AnyHashable: Any] = [
            "MACHINE_COST": jobRequest.machineCost,
            "NUM_LOADS_ACTUAL": jobRequest.numLoadsActual,
            "AMOUNT_PAID": jobRequest.amountPaid
        ]
        updateJobRequest(jobRequest: jobRequest, fields: fields)
    }
    
    func udpateOnDasherCompletion(jobRequest: JobRequest) {
        let fields: [AnyHashable: Any] = [
            "COMPLETED_TIMESTAMP": jobRequest.completedTimestamp
        ]
        updateJobRequest(jobRequest: jobRequest, fields: fields)

    }
    
    // MARK: - Job Reqeust writes/updates after completion/cancellation to jobsCompleted/jobID
    
    func writeCompletedJobOnDasherCompletion(jobRequest: JobRequest) {
    /*
         Caller: DasherJobStatusController ON(user clicks stage9updatebutton)
    */
        let docRef = db.collection("jobsCompleted")
            .document(jobRequest.jobID)
        let data = jobRequest.toJobsCompletedData()
        docRef.setData(data) { (error) in
            guard let error = error else {return}
            print("JRF.writecompletedJobOnDasherCompletion() Error: \(error)")
        }
    }
    
    func udpateCompletedJobOnCustomerReview(jobRequest: JobRequest) {
    /*
         Caller: CustomerReviewController ON(user clicks submit review button)
    */
        let docRef = db.collection("jobsCompleted")
            .document(jobRequest.jobID)
        let fields: [AnyHashable: Any] = [
            "CUSTOMER_REVIEW": jobRequest.customerReview,
            "CUSTOMER_RATING": jobRequest.customerRating
        ]
        docRef.updateData(fields) { (error) in
            guard let error = error else {return}
            print("JRF.updateCompletedJobOnCustomerReview() Error: \(error)")
        }
    }
    
    
    // MARK: - Reads from Firebase
    
    func getOldestJobRequest(availableToDasher dasher: Dasher) {
        let pendingRef = db.collection("dorms")
            .document(dasher.dorm)
            .collection("jobsPendingAssignment")
        let oldestPendingRef = pendingRef
            .order(by: "REQUEST_TIMESTAMP")
            .limit(to: 1)
        oldestPendingRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                // TODO: HANDLE_ERROR
                print("Error occured fetching oldest document: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let jobID = document.documentID
                    self.getInProgressJobRequest(fromDocumentID: jobID)
                    pendingRef.document(jobID).delete()
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func getInProgressJobRequest(fromDocumentID documentID: String) {
    /*
         Caller: self.getOldestJobRequest()
    */
        let docRef = db.collection("jobsInProgress")
            .document(documentID)
        docRef.getDocument { (document, error) in
            if let document = document {
                let documentData = document.data()!
                let jobRequest = JobRequest(fromDocData: documentData)
            
                self.delegate?.sendJobRequest(jobRequest: jobRequest)
            } else {
                // TODO: HANDLE_ERROR
                guard let error = error else {return}
                print("Error occured fetching job reqest document: \(error)")
                
            }
        }
    }
    
    func getInProgressJobRequest(jobID: String) {
        let docRef = db.collection("jobsInProgress")
            .document(jobID)
        docRef.getDocument { (document, error) in
            if let document = document {
                let documentData = document.data()!
                let jobRequest = JobRequest(fromDocData: documentData)
                
                self.delegate?.sendAcceptedJobRequest(jobRequest: jobRequest)
            } else {
                // TODO: HANDLE_ERROR
                guard let error = error else {return}
                print("Error occured fetching job reqest document: \(error)")
                
            }
        }
    }
    
    private func updateJobRequest(jobRequest: JobRequest, fields: [AnyHashable: Any]) {
        let inProgressDocRef = db.collection("jobsInProgress")
            .document(jobRequest.jobID)
        inProgressDocRef.updateData(fields) { (error) in
            if let error = error {
                print("JobRequestFirestore.updateJobRequest() Error: \(error)")
            }
        }
    }
    
    // MARK: - Completed Jobs
    
    func getCompletedJobs(forUserType userType: String, withUID uid: String) {
        let userDocRef = db.collection("\(userType)s")
            .document(uid)
        let completedJobsCollectionRef = db.collection("jobsCompleted")
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let userDoc: DocumentSnapshot
            do {
                try userDoc = transaction.getDocument(userDocRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            guard let jobIDs = userDoc.data()?["COMPLETED_JOBS"] as? [String] else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to fetch COMPLETED_JOBS field from doc: \(userType)/\(uid)"
                    ])
                errorPointer?.pointee = error
                return nil
            }
            var jobRequests: [JobRequest] = []
            var jobDoc: DocumentSnapshot

            for jobID in jobIDs {
                do {
                    try jobDoc = transaction.getDocument(completedJobsCollectionRef.document(jobID))
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                guard let jobDocData = jobDoc.data() else {
                    let error = NSError(
                        domain: "AppErrorDomain",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "JobRequest document with jobID: \(jobID) was empty"
                        ])
                    errorPointer?.pointee = error
                    return nil
                }
                let jobRequest = JobRequest(fromDocData: jobDocData)
                jobRequests.append(jobRequest)
            }
            self.delegate?.sendCompletedJobs(jobRequests: jobRequests)
            return nil
        }) { (object, error) in
            if let error = error {
                print("JobRequestFirestore.getCompletedJobs() Error: Transaction failed with \(error)")
            }
        }
    }
    
    // MARK: - Test
    
    func updateOnDasherReject(jobID: String) {
        // set wasCancelled = true for JIP colelction jobID document when dasher rejects customers specific requesrt
        let inProgressDocRef = db.collection("jobsInProgress")
            .document(jobID)
        let fields: [AnyHashable: Any] = [
            "WAS_REJECTED": true
        ]
        inProgressDocRef.updateData(fields) { (error) in
            if let error = error {
                print("JobRequestFirestore. Error: \(error)")
            }
        }
    }
}
