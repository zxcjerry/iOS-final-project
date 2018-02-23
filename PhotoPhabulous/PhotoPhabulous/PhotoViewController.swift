//
//  PhotoViewController.swift
//  PhotoPhabulous
//
//  Created by  jerry on 2/21/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit

class PhotoViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties

    let Network = SharedNetworking.shared
    let reuseIdentifier = "PhotoCell"
    let itemsPerRow : CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let username : NSString = "jingjiew"
    var photos = [PhotoDetail]()
    var imagePicked : UIImage?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let backgroundView : UIImageView = {
            let bgv = UIImageView()
            bgv.image = #imageLiteral(resourceName: "background")
            bgv.contentMode = .scaleAspectFill
            return bgv
        }()
        
        self.collectionView?.backgroundView = backgroundView
        
        ReloadImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let cell = sender as? UICollectionViewCell,
            let IndexPath = self.collectionView?.indexPath(for: cell) {
            
            let vc = segue.destination as? ImageDetailViewController
            
            vc?.detail = photos[IndexPath.row]
        }
    }
    

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
    
        // Configure the cell
        cell.photo = photos[indexPath.row]
        cell.LoadImage()
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    // MARK: - Networking
    
    func ReloadImages() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Network.pullImage(user: username) {(results) in
            
            DispatchQueue.main.async {
                if let results = results {
                    print("Found \(results.photos.count) photos")
                    self.photos.removeAll()
                    self.photos = results.photos
                    self.collectionView?.reloadData()
                }
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func UploadImage() {
        
        if let imageupload = imagePicked {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            Network.uploadRequest(user: username, image: imageupload, caption: "Caption")
        }
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func ReloadView(_ sender: Any) {
        ReloadImages()
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        print("Taking photo")
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        print("Choosing photo")
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    // MARK: - UIImagePickerControllerDelegate
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked = image
        print("Here now")
        // print(imagePicked)
        UploadImage()
        print("---------------------------------")
        ReloadImages()
        print("---------------------------------")
        dismiss(animated:true, completion: nil)
    }

}

extension PhotoViewController : UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,  layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,  layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


