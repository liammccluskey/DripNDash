//
//  Protocols.swift
//  DripNDash
//
//  Created by Marty McCluskey on 2/14/20.
//  Copyright © 2020 Liam McCluskey. All rights reserved.
//

protocol SignInControllerDelegate {
    func signIn(userClass: String)
    func register()
}

protocol RegisterControllerDelegate {
    func register(userClass: String)
}


