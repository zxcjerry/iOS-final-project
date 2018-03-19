//
//  ViewController.swift
//  FinalProject
//
//  Created by  jerry on 3/15/18.
//  Copyright © 2018  jerry. All rights reserved.
//

/// - Attribution: https://firebase.google.com/docs/ios/setup?authuser=0
/// - Attribution: https://cocoapods.org/pods/SwiftKeychainWrapper

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper


class ViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userimageView: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.layer.borderColor = UIColor.black.cgColor
        usernameField.layer.borderWidth = 1.0
        usernameField.layer.cornerRadius = 8.0
        usernameField.layer.masksToBounds = true
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.layer.borderWidth = 1.0
        emailField.layer.cornerRadius = 8.0
        emailField.layer.masksToBounds = true
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.layer.borderWidth = 1.0
        passwordField.layer.cornerRadius = 8.0
        passwordField.layer.masksToBounds = true

        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "toFeed", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userimageView.image = nil
        emailField.text = ""
        usernameField.text = ""
        passwordField.text = ""
    }
    
    // MARK: - Actions
    /**
    Function to sign up for a new user
     
     - parameter userUid: the unique Uid given by Firebase Auth
 
    */
    func setupUser(userUid: String) {
        if let imageData = UIImageJPEGRepresentation(self.userimageView.image!, 0.2) {
            let imageUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            Storage.storage().reference().child(imageUid).putData(imageData, metadata: metaData) { (metadata, error) in
                
                if error != nil {
                    print("Some error in auth!")
                }
                
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
            if email == "" || password == "" {
                let alert = UIAlertController(title: "Can't Sign in", message: "Email and password can't be empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else{
                // try to sign in
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error != nil{
                        let alert = UIAlertController(title: "Can't Sign in", message: "Wrong email or wrong password", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
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
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            if email == "" || password == "" {
                let alert = UIAlertController(title: "Can't Sign up", message: "Email and password can't be empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else{
                if !(self.usernameField.text?.isEmpty)! && self.userimageView.image != nil {
                    // Create Account
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Wrong email", message: "This email has already been used!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        } else {
                            self.setupUser(userUid: (user?.uid)!)
                            KeychainWrapper.standard.set((user?.uid)!, forKey: "uid")
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Can't Sign up", message: "You must fill in the username and photos when signing up", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func choosePhoto (_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.present(imagePicker, animated: true, completion: nil)
        }
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


