//
//  FilesViewController.swift
//  FinalProject
//
//  Created by  jerry on 3/16/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper

class FilesViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UITextView!
    var userImage: UIImage!
    var userName: String!
    
    var imagePicker: UIImagePickerController!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.image = userImage
        userNameLabel.text = userName
       
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func updateFile(_ sender: Any) {
        
        let userID = Auth.auth().currentUser?.uid
        if let imageData = UIImageJPEGRepresentation(userImageView.image!, 0.2) {
            let imageUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            Storage.storage().reference().child(imageUid).putData(imageData, metadata: metaData) { (metadata, error) in
                
                if error != nil {
                    print("Some error in auth!")
                }
                
                let downloadURL = metadata?.downloadURL()?.absoluteString
                
                let userData = [
                    "username" : self.userNameLabel.text!,
                    "userImg"  : downloadURL!
                    ] as [String : Any]
                
                Database.database().reference().child("users").child(userID!).setValue(userData)
                
                let alert = UIAlertController(title: "Update Successful", message: "You have updated your file", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
    }
    
    @IBAction func changePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension  FilesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImageView.image = image
        } else {
            print("Image hasn't been selected!")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

