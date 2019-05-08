//
//  HomeViewController.swift
//  Instagram
//
//  Created by ARY@N on 29/04/19.
//  Copyright © 2019 ARYAN. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logOutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let logoutError{
            print(logoutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signinVC = storyboard.instantiateViewController(withIdentifier: "SigninViewController")
        self.present(signinVC, animated: true, completion: nil)
    }
}
