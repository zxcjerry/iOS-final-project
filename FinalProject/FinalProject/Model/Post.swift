//
//  Post.swift
//  FinalProject
//
//  Created by  jerry on 3/16/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

/// Posts: a class to store all the information for a single post
class Post {
    private var _username: String!
    private var _userImg: String!
    private var _postText: String!
    private var _postKey:  String!
    private var _postRef: DatabaseReference!
    
    var username: String {
        return _username
    }
    
    var userImg: String {
        return _userImg
    }
    
    var postText: String {
        return _postText
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(postText: String, username: String, userImg: String) {
        _postText = postText
        _username = username
        _userImg = userImg
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        _postKey = postKey
        
        if let username = postData["username"] as? String {
            _username = username
        }
        
        if let userImg = postData["userImg"] as? String {
            _userImg = userImg
        }
        
        if let postText = postData["postText"] as? String {
            _postText = postText
        }
        
        _postRef = Database.database().reference().child("posts").child(_postKey)
    }
}
