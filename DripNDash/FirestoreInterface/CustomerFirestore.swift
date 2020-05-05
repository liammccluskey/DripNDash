//
//  CustomerFirestore.swift
//  DripNDash
//
//  Created by Liam McCluskey on 2/20/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

// written by: Liam McCluskey
// tested by: Liam McCluskey
// debugged by: Liam McCluskey

import Firebase

class CustomerFirestore {
    
    // MARK: - Properties
    
    var delegate: CustomerFirestoreDelegate?
    
    let customersRef = Firestore.firestore().collection("customers")
    
    // Mark: - Registration
    
    func isValidRegistration(email: String, dorm: String, dormRoom: String, password: String, confirmPassword: String) -> Bool {
        // email: verify is rutgers email
        // dorm: verify dorm exists
        // dormRoom: verify dormRoom in dorm
        // password: verify == confirmPassword and >= 6 characters
        return true
    }
    
    func initCustomerData(customer: Customer) {
        customersRef.document(customer.uid).setData([
            "UID": customer.uid,
            "FIRST_NAME": customer.firstName,
            "LAST_NAME": customer.lastName,
            "EMAIL": customer.email,
            "DORM": customer.dorm,
            "DORM_ROOM": customer.dormRoom,
            "COMPLETED_JOBS": customer.completedJobs
        ]) { (error) in
            if let error = error {
                print("CustomerRegisterController.initCustomerData() Error: \(error)")
            }
        }
        // Set currentUser.displayName to "customer", used to sign in
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "customer"
        changeRequest?.commitChanges { (error) in
            if let error = error {
                print("CustomerRegisterController.registerAction() Error: couldn't set display name \(error)")
            }
        }
    }
    
    func getCustomer(uid: String) {
        let docRef = customersRef.document(uid)
        docRef.getDocument { (document, error) in
            if let document = document {
                guard let docData = document.data() else {return}
                let customer = Customer(
                    uid: uid,
                    firstName: docData["FIRST_NAME"] as! String,
                    lastName: docData["LAST_NAME"] as! String,
                    email: docData["EMAIL"] as! String,
                    dorm: docData["DORM"] as! String,
                    dormRoom: docData["DORM_ROOM"] as! Int,
                    completedJobs: docData["COMPLETED_JOBS"] as! [String]
                )
                self.delegate?.sendCustomer(customer: customer)
            } else {
                self.delegate?.sendCustomer(customer: nil)
            }
        }
    }
    
    // MARK: - Profile Updates
    
    func addCompletedJob(jobID: String, forCustomerUID uid: String) {
        let docRef = customersRef.document(uid)
        docRef.updateData([
            "COMPLETED_JOBS": FieldValue.arrayUnion([jobID])
        ])
    }
}
