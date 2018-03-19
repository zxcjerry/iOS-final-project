//
//  CircleView.swift
//  FinalProject
//
//  Created by  jerry on 3/16/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit

/// the class to make the user image to be a circle
class CircleView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        //- Attributions: https://stackoverflow.com/questions/25587713/how-to-set-imageview-in-circle-like-imagecontacts-in-swift-correctly
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width/2
    }

}
