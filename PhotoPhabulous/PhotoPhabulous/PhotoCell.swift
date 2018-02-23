//
//  PhotoCell.swift
//  PhotoPhabulous
//
//  Created by  jerry on 2/21/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit

class PhotoDetail {
    var image : UIImage?
    var URL: String
    
    init(URL: String) {
        self.URL = URL
    }
    
    func getPhotoURL() -> URL?{
        if let url = Foundation.URL(string: "http://stachesandglasses.appspot.com/\(URL)") {
            return url
        }
        return nil
    }
}

class PhotoCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    var photo : PhotoDetail!
    
    func LoadImage() {
        imageView.image = photo.image
    }
}
