//
//  ViewController.swift
//  FinalProject
//
//  Created by  jerry on 3/15/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userimageView: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.object(forKey: "uid") {
            self.performSegue(withIdentifier: "toFeed", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUser(userUid: String) {
        if let imageData = UIImageJPEGRepresentation(self.userimageView.image!, 0.2) {
            let imageUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            Storage.storage().reference().child(imageUid).putData(imageData, metadata: metaData) { (metadata, error) in
                
                let downloadURL = metadata?.downloadURL()?.absoluteString
                
                let userData = [
                    "username" : self.usernameField.text!,
                    "userImg"  : downloadURL!
                ] as [String : Any]
                
                Database.database().reference().child("users").child(userUid).setValue(userData)
                self.performSegue(withIdentifier: "toFeed", sender: nil)
            }
        }
    }
    
    @IBAction func signinPressed(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            // try to sign in
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil && !(self.usernameField.text?.isEmpty)! && self.userimageView.image != nil{
                    // Create Account
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        KeychainWrapper.standard.set((user?.uid)!, forKey: "uid")
                        self.setupUser(userUid: (user?.uid)!)
                    }
                } else {
                    // Save the keychain and perform a segueway
                    if let userID = user?.uid {
                        KeychainWrapper.standard.set((userID), forKey: "uid")
                        self.performSegue(withIdentifier: "toFeed", sender: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func choosePhoto (_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userimageView.image = image
        } else {
            print("Image hasn't been selected!")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


