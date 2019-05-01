//
//  SignupViewController.swift
//  Instagram
//
//  Created by ARY@N on 28/04/19.
//  Copyright © 2019 ARYAN. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignupViewController: UIViewController {
    
    var selectedImage: UIImage?

    @IBOutlet weak var profileImages: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.backgroundColor = .clear
        usernameTextField.tintColor = .white
        usernameTextField.textColor = .white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerUsername = CALayer()
        bottomLayerUsername.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerUsername.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        usernameTextField.layer.addSublayer(bottomLayerUsername)
        
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
        
        profileImages.layer.cornerRadius = 53
        profileImages.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.handleSelectProfileImageView))
        profileImages.addGestureRecognizer(tapGesture)
        profileImages.isUserInteractionEnabled = true
    }
    @objc func handleSelectProfileImageView(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    @IBAction func dismissOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            let uid = user?.user.uid
            let storageRef = Storage.storage().reference().child("ProfileImages").child(uid!)
            if let profileImg = self.selectedImage,let imageData = profileImg.jpegData(compressionQuality: 0.1){
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        return
                    }
                    let imageURL = metadata
                    let ref = Database.database().reference()
                    let userRef = ref.child("users")
                    let newUserRef = userRef.child(uid!)
                    newUserRef.setValue(["Username":self.usernameTextField.text!,"Email":self.emailTextField.text!,"imageURL":imageURL])
                    print(newUserRef.description())
                    
                })
            }
        }
    }
}
extension SignupViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("did finish picking")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = image
            profileImages.image = image
        }
        print(info)
        dismiss(animated: true, completion: nil)
    }
}
