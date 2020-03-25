//
//  DasherFirestore.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/20/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

import Firebase

class DasherFirestore {
    
    // MARK: - Properties
    
    var delegate: DasherFirestoreDelegate?
    let db = Firestore.firestore()
    let dashersRef = Firestore.firestore().collection("dashers")
    
    // MARK: - Init
    
    // Interface
    
    func isValidRegistration(email: String, dorm: String, dormRoom: String, password: String, confirmPassword: String) -> Bool {
        // email: verify is rutgers email
        // dorm: verify dorm exists
        // dormRoom: verify dormRoom in dorm
        // password: verify == confirmPassword and >= 6 characters
        return true
    }
    
    func initDasherData(dasher: Dasher) {
        dashersRef.document(dasher.uid).setData([
            "UID": dasher.uid,
            "FIRST_NAME": dasher.firstName,
            "LAST_NAME": dasher.lastName,
            "EMAIL": dasher.email,
            "DORM": dasher.dorm,
            "DORM_ROOM": dasher.dormRoom,
            "COMPLETED_JOBS": dasher.completedJobs,
            "NUM_COMPLETED_JOBS": dasher.numCompletedJobs,
            "RATING": dasher.rating,
            "REGISTER_TIMESTAMP": dasher.registerTimestamp
        ]) { (error) in
            if let error = error {
                // TODO: HANDLE_ERROR
                print("DasherFirestore.initDasherData() Error: \(error)")
            }
        }
        // Set currentUser.displayName to "dasher", used to sign in
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "dasher"
        changeRequest?.commitChanges { (error) in
            if let error = error {
                print("CustomerRegisterController.registerAction() Error: couldn't set display name \(error)")
            }
        }
    }
    
    func getDasher(uid: String) {
        print("ran DasherFirestore.getDasher()")
        let docRef = dashersRef.document(uid)
        docRef.getDocument { (document, error) in
            if let document = document {
                guard let docData = document.data() else {
                    print("DasherFirestore.getDasher(): dasher document data was nil")
                    return
                }
                let dasher = Dasher(
                    uid: uid,
                    firstName: docData["FIRST_NAME"] as! String,
                    lastName: docData["LAST_NAME"] as! String,
                    email: docData["EMAIL"] as! String,
                    dorm: docData["DORM"] as! String,
                    dormRoom: docData["DORM_ROOM"] as! Int,
                    rating: docData["RATING"] as! Double,
                    numCompletedJobs: docData["NUM_COMPLETED_JOBS"] as! Int,
                    registerTimestamp: docData["REGISTER_TIMESTAMP"] as! Timestamp,
                    completedJobs: docData["COMPLETED_JOBS"] as! [String]
                )
                self.delegate?.sendDasher(dasher: dasher)
                print("DasherFirestore.getDasher(): sent dasher")
            } else {
                // TODO: HANDLE_ERROR
                guard let error = error else {return}
                print("DasherFirestore.getDasher() Error: \(error)")
                self.delegate?.sendDasher(dasher: nil)
            }
        }
    }
    
    // MARK: - Profile Updates
    
    func addCompletedJob(jobID: String, forDasherUID uid: String) {
        let docRef = dashersRef.document(uid)
        docRef.updateData([
            "COMPLETED_JOBS": FieldValue.arrayUnion([jobID])
            ])
    }
    
    func updateRating(ofDasherUID uid: String, withRating rating: Double) {
        let docRef = dashersRef.document(uid)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let doc: DocumentSnapshot
            do {
                try doc = transaction.getDocument(docRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            guard let oldRating = doc.data()?["RATING"] as? Double else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to fetch RATING field from \(doc)"
                    ])
                errorPointer?.pointee = error
                return nil
            }
            guard let oldNumJobs = doc.data()?["NUM_JOBS_COMPLETED"] as? Double else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to fetch NUM_JOBS_COMPLETED field data from \(doc)"
                    ])
                errorPointer?.pointee = error
                return nil
            }
            let newRating: Double = (rating + oldRating*oldNumJobs)/(oldNumJobs + 1)
            transaction.updateData([
                "RATING": newRating,
                "NUM_JOBS_COMPLETED": FieldValue.increment(Int64(1))
            ], forDocument: docRef)
            return nil
        }) { (object, error) in
            if let error = error {
                print("DasherFirestore.updateRating() Error: Transaction failed with \(error)")
            }
        }
    }
}

