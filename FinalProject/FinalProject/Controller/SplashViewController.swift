//
//  SplashViewController.swift
//  FinalProject
//
//  Created by  jerry on 3/17/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(showLogin), with: nil, afterDelay: 2)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func showLogin() {
        performSegue(withIdentifier: "toLogin", sender: self)
    }

}
