//
//  JobRequestFirestore.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/24/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import Firebase

class JobRequestFirestore {
    
    // MARK: Properties
    
    var delegate: JobRequestFirestoreDelegate?
    
    let db = Firestore.firestore()
    
    // MARK: - Init Writes (or rewrites) of Job Request

    func writeJobRequest(jobRequest: JobRequest, isRewrite: Bool) {
    /*
        Writes the customer's job request to Firestore
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
        let inProgressDocData: [String: Any] = [
            "JOB_ID": jobRequest.jobID,
            "REQUEST_TIMESTAMP": jobRequest.requestTimestamp,
            "DORM": jobRequest.dorm,
            "DORM_ROOM": jobRequest.dormRoom,
            "NUM_LOADS": jobRequest.numLoads,
            "CURRENT_STAGE": jobRequest.currentStage,
            "ASSIGNED_TIMESTAMP": "",
            "COMPLETED_TIMESTAMP": "",
            "DASHER_UID": "",
            ]
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
    
    // MARK: - Updates to Job Request while in progress
    
    func updateOnAssignment(jobRequest: JobRequest) {
        let fields: [AnyHashable: Any] = [
            "DASHER_UID": jobRequest.dasherUID,
            "ASSIGNED_TIMESTAMP": jobRequest.assignedTimestamp,
            "CURRENT_STAGE": jobRequest.currentStage
        ]
        updateJobRequest(jobRequest: jobRequest, fields: fields)
    }
    
    func updateOnWorkerUpdate(jobRequest: JobRequest) {
        let fields: [AnyHashable: Any] = [
            "CURRENT_STAGE": jobRequest.currentStage
        ]
        updateJobRequest(jobRequest: jobRequest, fields: fields)
    }
    
    func updateJobRequest(jobRequest: JobRequest, fields: [AnyHashable: Any]) {
        let inProgressDocRef = db.collection("jobsInProgress")
            .document(jobRequest.jobID)
        inProgressDocRef.updateData(fields) { (error) in
            if let error = error {
                print("JobRequestFirestore.updateJobRequest() Error: \(error)")
            }
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
                    // Read the documentID, use it to read the IPJ_doc and create jobrequest obj from it
                    let jobID = document.documentID
                    self.getInProgressJobRequest(fromDocumentID: jobID, andAssignTo: dasher)
                    pendingRef.document(jobID).delete()
                }
            }
        }
    }
    
    func addListenerToJobRequest(jobRequest: JobRequest) {
        let pendingDocRef = db.collection("dorms")
            .document(jobRequest.dorm)
            .collection("jobsPendingAssignment")
            .document(jobRequest.jobID)
        
        pendingDocRef.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("JRF.addListenerToJobRequest() Error: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("JRF.addListenerToJobRequest() Error: Document was empty)")
                    return
                }
            jobRequest.assignedTimestamp = data["ASSIGNED_TIMESTAMP"] as? Timestamp ?? Timestamp(date: Date())
            jobRequest.currentStage = data["CURRENT_STAGE"] as? Int ?? 0
            jobRequest.dasherUID = data["DASHER_UID"] as? String ?? ""
            self.delegate?.sendUpdatedJobRequest(jobRequest: jobRequest)
            
            print("JRF.addListenerToJobRequest(): Value did change")
        }
    }
    
    // MARK: - Helpers
    
    func getInProgressJobRequest(fromDocumentID documentID: String, andAssignTo dasher: Dasher) {
    /*
        Sends the JobRequest object with the delegate method
    */
        let docRef = db.collection("jobsInProgress")
            .document(documentID)
        docRef.getDocument { (document, error) in
            if let document = document {
                let documentData = document.data()!
                
                let jobRequest = JobRequest(
                    jobID: documentData["JOB_ID"] as! String,
                    requestTimestamp: documentData["REQUEST_TIMESTAMP"] as! Timestamp,
                    dorm: documentData["DORM"] as! String,
                    dormRoom: documentData["DORM_ROOM"] as! Int,
                    numLoads: documentData["NUM_LOADS"] as! Int
                )
                jobRequest.dasherUID = dasher.uid
                jobRequest.assignedTimestamp = Timestamp(date: Date())
                
                self.delegate?.sendJobRequest(jobRequest: jobRequest)
            } else {
                // TODO: HANDLE_ERROR
                guard let error = error else {return}
                print("Error occured fetching job reqest document: \(error)")
                
            }
        }
    }
}
