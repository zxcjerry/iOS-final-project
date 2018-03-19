//
//  PersonalViewController.swift
//  FinalProject
//
//  Created by  jerry on 3/16/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class PersonalViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    let Network = SharedNetworking.shared
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUsersData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showfile" {
            let vc = segue.destination as? FilesViewController
            vc?.userImage = userImage.image
            vc?.userName = userNameLabel.text
        } else if segue.identifier == "showMyPosts" {
            let vc = segue.destination as? MyPostsTableViewController
            vc?.currentUserName = self.userNameLabel.text
        }
    }
    
    // MARK: - Actions
    func getUsersData() {
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            self.userNameLabel.text = data["username"] as? String
            let userImgURL = data["userImg"] as? String
            
            if let userimageURL = userImgURL {

                self.Network.pullImage(userimageURL: userimageURL) { (img) in
                    self.userImage.image = img
                }
                
            } else {
                print("error parsing image url")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}
