//
//  MainTableViewCell.swift
//  FinalProject
//
//  Created by  jerry on 3/15/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MainTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var userimageView: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    
    let Network = SharedNetworking.shared
    
    // MARK: - Navigation
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /**
     Function to set up all the settings in the cell
     
     - parameter userimageURL: the URL of the userimage
 
     */
    func configCell(userimageURL: String) {
        Network.pullImage(userimageURL: userimageURL) { (img) in
            self.userimageView.image = img
        }

    }
    
}
