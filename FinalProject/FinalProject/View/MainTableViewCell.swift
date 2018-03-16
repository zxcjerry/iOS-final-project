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

    @IBOutlet weak var userimageView: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configCell(userimageURL: String) {
        let httpsReference = Storage.storage().reference(forURL: userimageURL)
        
        httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                let image = UIImage(data: data!)
                self.userimageView.image = image
            }
        }
    }
    
}
