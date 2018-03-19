//
//  SharedNetworking.swift
//  FinalProject
//
//  Created by  jerry on 3/17/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

/// a singleton class to handle all the image Downloading and save the images to NSCache
class SharedNetworking {
    // MARK: - Properties
    
    static let shared = SharedNetworking()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    
    // MARK: - Networking Functions
    /**
     Pull the image Data from Firebase Storage with the imagURL
     - parameter userimageURL: URL for the image
     - parameter completion: A block to execute
     - parameter img: the downloaded UIImage
     */
    func pullImage(userimageURL: String, completion: @escaping (_ img: UIImage?) -> Void){
        
        if let localimage = imageCache.object(forKey: userimageURL as NSString) {
            completion(localimage)
        } else {
            let ref = Storage.storage().reference(forURL: userimageURL)
            ref.getData(maxSize: 100000000, completion: { (data, error) -> Void in
                if error != nil {
                    print("couldnt load img")
                } else {
                    let image = UIImage(data: data!)
                    self.imageCache.setObject(image!, forKey: userimageURL as NSString)
                    completion(image)
                }
            })
        }
    }
    
}

