//
//  PostImageViewController.swift
//  InstagramClone
//
//  Created by Eric Vandenberg on 8/30/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBOutlet weak var messageToPost: UITextField!
    
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        
        saveInBackground()
        
    }
    
    func saveInBackground() {
        
        var post = PFObject(className: "Post")

        post["message"] = "temporary"
        post["userId"] = PFUser.currentUser()?.objectId
        
        let imageData = UIImageJPEGRepresentation(imageToPost.image!, 1)
        let imageFile = PFFile(name: "image.jpg", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackground()
        
    }
    
    
    @IBAction func postImage(sender: AnyObject) {
        
        var texti = messageToPost.text!
        print("this is the first \(texti)")
        
        var query = PFQuery(className: "Post")
        
        query.whereKey("userId", equalTo: PFUser.currentUser()!.objectId!)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    var anotherQuery = PFQuery(className: "Post")
                    
                    anotherQuery.whereKey("message", equalTo: "temporary")
                    
                    anotherQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        
                        if let objects = objects {
                            
                            var objectIdArray = [String]()
                            
                            for object in objects {
                                
                                objectIdArray.append(object.objectId!!)
                                
                                
                            }
                            
                            anotherQuery.getObjectInBackgroundWithId(objectIdArray[0]) { (post: PFObject?, error: NSError?) -> Void in
                                if error != nil {
                                    
                                    self.displayAlert("Could Not Post :(", message: String(error))
                                    return
                                    
                                } else if let post = post {
                                    
                                    
                                    post["message"] = texti
                                    post.saveInBackground()
                                    
                                }
                            }
                            
                        }
                        
                    })
                    
                }
                
            }
            
        }
        
        
        self.displayAlert("Posted!", message: "go check it out on your feed")
        
        self.imageToPost.image = UIImage(named: "placeholder.jpg")
        self.messageToPost.text = ""
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
