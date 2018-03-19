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
    
    // MARK: - Properties
    var refresher: UIRefreshControl!
    var currentUserImageUrl: String!
    var currentUserName: String!
    var posts = [Post]()
    var selectedPost: Post!
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        getPosts()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signout))
    
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPosts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "comments" {
            let vc = segue.destination as? CommentTableViewController
            let cellIndex = tableView.indexPathForSelectedRow?.row
            vc?.post = posts[cellIndex!-1]
        }
    }
    
    // MARK: - Actions
    /**
     Signout Function for the bar button Signout
    */
    @objc func signout (_ sender: AnyObject) {
        KeychainWrapper.standard.removeObject(forKey: "uid")
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Function to get the data for the current user
    */
    func getUserData() {
        let uid = KeychainWrapper.standard.string(forKey: "uid")
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) {(snapshot) in
            
            if let postDict = snapshot.value as? [String : AnyObject]{
                self.currentUserImageUrl = postDict["userImg"] as! String
                self.currentUserName = postDict["username"] as! String
            }
            
        }
    }
    
    /**
     Function to get all the posts from the Database
    */
    func getPosts() {
        Database.database().reference().child("textPosts").observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.posts.removeAll()
            for data in snapshot.reversed() {
                guard let postDict = data.value as? Dictionary<String, AnyObject> else { return }
                let post = Post(postKey: data.key, postData: postDict)
                self.posts.append(post)
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        getPosts()
    }
    
    @objc func createPost (_ sender: AnyObject) {
        performSegue(withIdentifier: "createPost", sender: nil)
    }
    
    @objc func refreshTable() {
        getPosts()
        refresher.endRefreshing()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // First cell is the user cell
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as? MainTableViewCell {
                if currentUserImageUrl != nil {
                    cell.configCell(userimageURL: currentUserImageUrl)
                    cell.shareBtn.addTarget(self, action: #selector(createPost), for: .touchUpInside)
                }
                return cell
            }
        }
        // Cell other than the first cell are all posts cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell else { return UITableViewCell() }
        cell.configCell(post: posts[indexPath.row-1])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70.0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
}
