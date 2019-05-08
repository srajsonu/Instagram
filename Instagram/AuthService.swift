//
//  AuthService.swift
//  Instagram
//
//  Created by ARY@N on 08/05/19.
//  Copyright © 2019 ARYAN. All rights reserved.
//

import Foundation
import FirebaseAuth
class AuthService {
    
    static func SignIn(email: String, password: String, onSuccess: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print(error?.localizedDescription as Any)
                return
            }
            onSuccess()
        }
    }
}
