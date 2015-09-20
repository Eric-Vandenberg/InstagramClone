//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var loginActive = true
    
    var resetText = ""
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var login: UIButton!
    
    @IBOutlet weak var signup: UIButton!
    
    @IBOutlet weak var regText: UILabel!
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if loginActive == true {
            
            signup.setTitle("Login", forState: UIControlState.Normal)
            
            regText.text = "already registered?"
            
            login.setTitle("Sign up", forState: UIControlState.Normal)
            
            loginActive = false
            
        } else {
            
            signup.setTitle("Sign up", forState: UIControlState.Normal)
            
            regText.text = "not registered yet?"
            
            login.setTitle("Login", forState: UIControlState.Normal)
            
            loginActive = true
        
        }
    
    
    }
    
    @IBAction func logIn(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Great, you want in", message: "Enter A Username and Password First")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()

            var errorMessage = "Please try again later"
            
            if loginActive == true {
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                    if user != nil {
                        
                        //logged in
                        print("Login successful")
                        self.performSegueWithIdentifier("loginSegue", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                            
                        }
                        
                        self.displayAlert("Failed Log In", message: errorMessage)
                        
                    }
                    
                })
                
            } else {

                var user = PFUser()
                user.username = username.text
                user.password = password.text
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        
                        self.displayAlert("Successful!", message: "You are signed up!")
                        
                        self.username.text = ""
                        self.password.text = ""
                        
                        print("signup successful")
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                            
                        }
                        
                        self.displayAlert("Failed Sign Up", message: errorMessage)
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        /*
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("loginSegue", sender: self)
            
        }
        */
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

