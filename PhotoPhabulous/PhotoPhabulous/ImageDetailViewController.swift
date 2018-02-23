//
//  ImageDetailViewController.swift
//  PhotoPhabulous
//
//  Created by  jerry on 2/21/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var image: UIImageView!
    
    var detail : PhotoDetail?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

         navigationController?.hidesBarsOnTap = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        image.image = detail?.image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }   

}
