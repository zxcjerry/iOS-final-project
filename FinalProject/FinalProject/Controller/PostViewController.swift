//
//  PostViewController.swift
//  FinalProject
//
//  Created by  jerry on 3/16/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var postText: UITextView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func post(_ sender: AnyObject) {
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            let username = data["username"]
            let userImg = data["userImg"]
            
            let post: Dictionary<String, AnyObject> = [
                "username": username as AnyObject,
                "userImg": userImg as AnyObject,
                "postText": self.postText.text as AnyObject
            ]
            
            let firebasePost = Database.database().reference().child("textPosts").childByAutoId()
            firebasePost.setValue(post)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        let alert = UIAlertController(title: "Post Successful", message: "You have share your post!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,
                                      handler: {action in self.navigationController?.popViewController(animated: true)}))
        self.present(alert, animated: true)
    }
    
}


