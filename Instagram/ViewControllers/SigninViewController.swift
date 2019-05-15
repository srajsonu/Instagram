//
//  ViewController.swift
//  Instagram
//
//  Created by ARY@N on 28/04/19.
//  Copyright © 2019 ARYAN. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class SigninViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .white
        passwordTextField.textColor = .white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        
        signinButton.isEnabled = false 
        handleTextField()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    //MARK - Auto- SignIn
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "signinToTabBarVC", sender: nil)
        }
    }
    func handleTextField(){
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self .textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    @objc func textFieldDidChange(){
        guard let email = emailTextField.text, !email.isEmpty,let password = passwordTextField.text, !password.isEmpty else {
            signinButton.setTitleColor(.lightText, for: UIControl.State.normal)
            signinButton.isEnabled = false
            return
        }
        signinButton.setTitleColor(.white, for: UIControl.State.normal)
        signinButton.isEnabled = true
    }
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        AuthService.SignIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            ProgressHUD.showSuccess("Success")
            self.performSegue(withIdentifier: "signinToTabBarVC", sender: nil)
        }) {error in
            ProgressHUD.showError(error!)
        }
       
    }
}
