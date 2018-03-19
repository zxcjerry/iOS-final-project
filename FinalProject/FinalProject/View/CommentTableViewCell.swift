//
//  CommentTableViewCell.swift
//  FinalProject
//
//  Created by  jerry on 3/16/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postText: UILabel!
    
    var post: Post!
    let Network = SharedNetworking.shared
    
    // MARK: - Navigation
    override func awakeFromNib() {
        super.awakeFromNib()
        postText.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /**
     Function to set up all the settings in the cell
     
     - parameter post: the post that include all the information of the cell
     
     */
    func configCell(post: Post) {
        self.post = post
        self.username.text = post.username
        self.postText.text = post.postText
        
        Network.pullImage(userimageURL: post.userImg) { (img) in
            self.userImg.image = img
        }
    }

}
