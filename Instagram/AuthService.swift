//
//  AuthService.swift
//  Instagram
//
//  Created by ARY@N on 08/05/19.
//  Copyright © 2019 ARYAN. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class AuthService {
    
    var imageURL: String?
    
    static func SignIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }

    static func SignUp(username: String, email: String, password: String,imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                onError(error!.localizedDescription)
                return
            }
            
            
            let uid = user?.user.uid
            let storageRef = Storage.storage().reference().child("ProfileImages").child(uid!)
            
           
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        return
                    }
//                    storageRef.downloadURL(completion: { (url, error) in
//                        if let metaImageURL = url?.absoluteString{
//                            
//                        }
//                    })
                    self.setUserInfo(username: username, email: email, uid: uid!, onSuccess: onSuccess)
                })
        }
    }
    static func setUserInfo(username: String,email: String,uid: String,onSuccess: @escaping () -> Void){
        let ref = Database.database().reference()
        let userRef = ref.child("Users")
        let newUserRef = userRef.child(uid)
        newUserRef.setValue(["username": username,"email" :email])
        onSuccess()
    }
}
