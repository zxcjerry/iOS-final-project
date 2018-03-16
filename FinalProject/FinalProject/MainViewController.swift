//
//  MainViewController.swift
//  FinalProject
//
//  Created by  jerry on 3/15/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class MainViewController: UITableViewController {

    var currentUserImageUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signout))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func signout (_ sender: AnyObject) {
        KeychainWrapper.standard.removeObject(forKey: "uid")
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func getUserData() {
        
        Database.database().reference().child("users").child(KeychainWrapper.standard.string(forKey: "uid")!).observeSingleEvent(of: .value) {(snapshot) in
            
            if let postDict = snapshot.value as? [String : AnyObject]{
                self.currentUserImageUrl = postDict["userImg"] as! String
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as? MainTableViewCell {
                if currentUserImageUrl != nil {
                    cell.configCell(userimageURL: currentUserImageUrl)
                    cell.shareBtn.addTarget(self, action: #selector(createPost), for: .touchUpInside)
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func createPost (_ sender: AnyObject) {
        print("share button tapped")
        performSegue(withIdentifier: "createPost", sender: nil)
    }
    
}
