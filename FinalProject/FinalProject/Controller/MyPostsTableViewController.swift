//
//  MyPostsTableViewController.swift
//  FinalProject
//
//  Created by  jerry on 3/17/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class MyPostsTableViewController: UITableViewController {
    // MARK: - Properties
    var refresher: UIRefreshControl!
    var currentUserName: String!
    var posts = [Post]()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
    }
    
    // MARK: - Actions
    func getPosts() {
        Database.database().reference().child("textPosts").observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.posts.removeAll()
            for data in snapshot.reversed() {
                guard let postDict = data.value as? Dictionary<String, AnyObject> else { return }
                let post = Post(postKey: data.key, postData: postDict)
                
                if post.username == self.currentUserName {
                    self.posts.append(post)
                }
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myPostCell") as? MyPostsTableViewCell else { return UITableViewCell() }
        cell.configCell(post: posts[indexPath.row])
        return cell
    }

}
