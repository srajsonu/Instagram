//
//  PhotosViewController.swift
//  Instagram
//
//  Created by ARY@N on 29/04/19.
//  Copyright © 2019 ARYAN. All rights reserved.
//

import UIKit
import ProgressHUD
import FirebaseStorage
import FirebaseDatabase
import ImagePicker

class PhotosViewController: UIViewController, ImagePickerDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photosView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photosView.addGestureRecognizer(tapGesture)
        photosView.isUserInteractionEnabled = true
        captionTextView.text = ""
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    func handlePost(){
        if selectedImage != nil{
            self.shareButton.isEnabled = true
            self.removeButton.isEnabled = true
            self.shareButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            self.shareButton.isEnabled = false
            self.removeButton.isEnabled = false
            self.shareButton.backgroundColor = .lightGray
        }
    }
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    @IBAction func cameraButtonPressed(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 5
        present(imagePickerController, animated: true, completion: nil)
    }
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        print("Wrapper")
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        guard let image = images.first else{
            dismiss(animated: true, completion: nil)
            return
        }
        selectedImage = image
        photosView.image = image
        dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        print("Cancel")
    }
    @IBAction func removeButtonPressed(_ sender: Any) {
        clean()
        handlePost()
    }
    @IBAction func shareButtonPressed(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        if let profileImg = self.selectedImage,let imageData = profileImg.jpegData(compressionQuality: 0.1){
            let photoID = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("Posts").child(photoID)
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        return
                    }
                    if let metaImageURL = url?.absoluteString{
                        print(metaImageURL)
                        //imageURL=metaImageURL
                    }
                })
                self.sendDataToDatabase()
                ProgressHUD.showSuccess("Success")
            })
        }else {
            ProgressHUD.showError("Profile image Can't be Empty")
        }
    }
    func sendDataToDatabase(){
        let ref = Database.database().reference()
        let postRef = ref.child("Posts")
        let newPostID = postRef.childByAutoId().key
        let newPostRef = postRef.child(newPostID!)
        newPostRef.setValue(["caption":captionTextView.text!],withCompletionBlock: {error,ref in
            if error != nil{
                ProgressHUD.showError(error?.localizedDescription)
            }
            ProgressHUD.showSuccess("Success")
            self.clean()
            self.tabBarController?.selectedIndex = 0  // return to home tab bar
        })
    }
    func clean(){
        self.captionTextView.text = ""
        self.photosView.image = UIImage(named: "placeholder")
        self.selectedImage=nil
    }
}
extension PhotosViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("did finish picking")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = image
            photosView.image = image
        }
        print(info)
        dismiss(animated: true, completion: nil)
    }
}
