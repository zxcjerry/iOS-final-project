//
//  CommentTableViewController.swift
//  FinalProject
//
//  Created by  jerry on 3/16/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CommentTableViewController: UITableViewController {

    // MARK: - Properties
    var refresher: UIRefreshControl!
    var post: Post!
    var posts = [Post]()
    @IBOutlet weak var commentTextfield: UITextView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getComments()
        
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    /**
     Functions to get all the comments for the posts
    */
    func getComments() {
        Database.database().reference().child("textPosts").child(post.postKey).child("comments").observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.posts.removeAll()
            for data in snapshot {
                guard let postDict = data.value as? Dictionary<String, AnyObject> else { return }
                let post = Post(postKey: data.key, postData: postDict)
                self.posts.append(post)
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func postComment(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            let username = data["username"]
            let userImg = data["userImg"]
            
            let post: Dictionary<String, AnyObject> = [
                "username": username as AnyObject,
                "userImg": userImg as AnyObject,
                "postText": self.commentTextfield.text as AnyObject
            ]
            
            let firebasePost = Database.database().reference().child("textPosts").child(self.post.postKey).child("comments").childByAutoId()
            firebasePost.setValue(post)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        getComments()
    }
    
    @objc func refreshTable() {
        getComments()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentcell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        if indexPath.row == 0 {
            cell.configCell(post: post)
        } else {
            cell.configCell(post: posts[indexPath.row - 1])
        }
        
        return cell
    }
    
}
