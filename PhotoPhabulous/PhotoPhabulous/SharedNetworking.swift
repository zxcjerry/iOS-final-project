//
//  SharedNetworking.swift
//  PhotoPhabulous
//
//  Created by  jerry on 2/21/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import Foundation
import UIKit
import ImageIO

struct ImageArray {
    var photos = [PhotoDetail]()
}

class SharedNetworking {
    // MARK: - Properties
    
    // implement of singleton
    static let shared = SharedNetworking()
    
    let session = URLSession.shared
    
    // MARK: - Functions
    /// function to upload a new image
    func uploadRequest(user: NSString, image: UIImage, caption: NSString) {
        
        let boundary = generateBoundaryString()
        let imageJPEGData = UIImageJPEGRepresentation(image,0.1)
        
        guard let imageData = imageJPEGData else {return}
        
        // Create the URL, the user should be unique
        let url = NSURL(string: "http://stachesandglasses.appspot.com/post/\(user)/")
        
        // Create the request
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Set the type of the data being sent
        let mimetype = "image/jpeg"
        // This is not necessary
        let fileName = "test.png"
        
        // Create data for the body
        let body = NSMutableData()
        body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        
        // Caption data (this is optional)
        body.append("Content-Disposition:form-data; name=\"caption\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("CaptionText\r\n".data(using: String.Encoding.utf8)!)
        
        // Image data
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        // Trailing boundary
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        // Set the body in the request
        request.httpBody = body as Data
        
        // Create a data task
        _ = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            // Need more robust errory handling here
            // 200 response is successful post
            print(response!)
            print(error as Any)
            
            // The data returned is the update JSON list of all the images
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            }.resume()
        
    }
    
    /// A unique string that signifies breaks in the posted data
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    /// Resize an image based on a scale factor
    func resize(image: UIImage, scale: CGFloat) -> UIImage {
        let size = image.size.applying(CGAffineTransform(scaleX: scale,y: scale))
        let hasAlpha = true
        
        // Automatically use scale factor of main screen
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    /// Function to pull down all the image urls
    func pullImage(user: NSString, completion:@escaping (_ results: ImageArray?) -> Void)  {
        
        // imageURLs.removeAll()
        
        guard let url = NSURL(string: "http://stachesandglasses.appspot.com/user/\(user)/json/") else {
            print("Can't get the url!")
            return
        }
                
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            // Ensure there were no errors returned from the request
            guard error == nil else {
                print("error")
                return
            }
            // Ensure there is data and unwrap it
            guard let data = data else {
                print("Data is nil")
                return
            }
                        
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                // Cast JSON as an array of dictionaries
                guard let results = json as? [String: AnyObject] else {
                    print("response")
                    return
                }
                
                let AllData = results["results"] as? [[String: AnyObject]]
                var photos = [PhotoDetail]()
                
                // parse json
                for json in AllData! {
                    //print(json)
                    guard let imagestring = json["image_url"] as? String else {
                        break
                    }
                    let photo = PhotoDetail(URL: imagestring)
                    
                    guard let realurl = photo.getPhotoURL(),
                        let imageData = try? Data(contentsOf: realurl as URL) else {
                            break
                    }
                    
                    if let image = UIImage(data: imageData) {
                        photo.image = image
                        photos.append(photo)
                    }
                    
                }
                
                completion(ImageArray(photos: photos))
                
            } catch {
                print("error serializing JSON: \(error)")
                return
            }
        })
        
        // Tasks start off in suspended state, we need to kick it off
        task.resume()
    }
    
}
