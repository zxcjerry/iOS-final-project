//
//  MyPostsTableViewCell.swift
//  FinalProject
//
//  Created by  jerry on 3/17/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SwiftKeychainWrapper

class MyPostsTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postText: UILabel!
    
    var post: Post!
    let currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    let Network = SharedNetworking.shared
    
    // MARK: - Navigation
    /**
     Function to set up all the settings in the cell
     
     - parameter post: the post that include all the information of the cell
     
     */
    func configCell(post: Post) {
        self.post = post
        self.username.text = post.username
        self.postText.text = post.postText
        
        Network.pullImage(userimageURL: post.userImg) { (img) in
            self.userImage.image = img
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
