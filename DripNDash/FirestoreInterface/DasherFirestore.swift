//
//  DasherFirestore.swift
//  DripNDash
//
//  Created by Liam McCluskey on 2/20/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

// written by: Liam McCluskey
// tested by: Liam McCluskey
// debugged by: Liam McCluskey

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
            "REGISTER_TIMESTAMP": dasher.registerTimestamp,
            "REQUESTS_PENDING_ACCEPT": []
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
            guard let document = document else {
                print("DasherFirestore.getDasher() Error: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("DasherFirestore.getDasher() Error: Document was empty)")
                return
            }
            let dasher = Dasher(fromDocData: data)
            self.delegate?.sendDasher(dasher: dasher)
        }
    }
    
    func updateDasherAvailability(forDasher dasher: Dasher, isAvailable: Bool) {
        let dasherDict: [String: Any] = [
            "NAME": "\(dasher.firstName) \(dasher.lastName)",
            "RATING": dasher.rating,
            "UID": dasher.uid
        ]
        let docRef = db.collection("dorms")
            .document(dasher.dorm)
        if isAvailable {
            docRef.updateData(["availableDashers": FieldValue.arrayUnion([dasherDict])]) { (error) in
                guard let error = error else {return}
                print("DasherFirestore.udpateDashervailability() error: \(error)")
            }
        } else {
            docRef.updateData(["availableDashers": FieldValue.arrayRemove([dasherDict])]) { (error) in
                guard let error = error else {return}
                print("DasherFirestore.udpateDashervailability() error: \(error)")
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
            guard let oldNumJobs = doc.data()?["NUM_COMPLETED_JOBS"] as? Double else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to fetch NUM_COMPLETED_JOBS field data from \(doc)"
                    ])
                errorPointer?.pointee = error
                return nil
            }
            let newRating: Double = (rating + oldRating*oldNumJobs)/(oldNumJobs + 1)
            transaction.updateData([
                "RATING": newRating,
                "NUM_COMPLETED_JOBS": FieldValue.increment(Int64(1))
            ], forDocument: docRef)
            return nil
        }) { (object, error) in
            if let error = error {
                print("DasherFirestore.updateRating() Error: Transaction failed with \(error)")
            }
        }
    }
    
    // MARK: Realtime Changes
    
    func addListenerToDasher(withUID uid: String) {
        let docRef = dashersRef.document(uid)
        docRef.addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("DasherFirestore.addListenerToDasher() Error: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("DasherFirestore.addListenerToDasher() Error: Document was empty)")
                return
            }
            let dasher = Dasher(fromDocData: data)
            self.delegate?.sendDasher(dasher: dasher)
            
            // check for specific requests
            let requestIDs = data["REQUESTS_PENDING_ACCEPT"] as! [String]
            if requestIDs.count > 0 {
                self.clearQueueAndNotify(dasherUID: uid, jobIDs: requestIDs)
            }
        }
    }
    
    func clearQueueAndNotify(dasherUID uid: String, jobIDs: [String]) {
        let docRef = dashersRef.document(uid)
        docRef.updateData(["REQUESTS_PENDING_ACCEPT": []]) { (error) in
            if let error = error {
                print(error)
            } else {
                self.delegate?.sendRequestsPendingAccept(jobIDs: jobIDs)
            }
        }
    }
    
    
}

