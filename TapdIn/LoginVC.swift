//
//  LoginVC.swift
//  OAI Kiosk
//
//  Created by Jim Rainville on 7/31/16.
//  Copyright © 2016 Jim Rainville. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    @IBAction func loginTapped(_ sender: AnyObject) {
        let username:String = txtUsername.text!
        let password:String = txtPassword.text!
        
        if ( username.isEmpty || password.isEmpty ) {
            let alert = UIAlertController(title: "Sign in Failed", message: "Please enter Username and Password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                // Code here when user hits 'OK'
            }
            alert.addAction(action)
            self.present(alert, animated: true) {}
            
        } else {
            let serviceEndpoint = "/api-token-auth/"
            let postDic = ["username": username, "password": password]
            
            let rc = RESTAccess()
            
            rc.post(postDic as Dictionary<String, AnyObject>, serviceEndpoint: serviceEndpoint) { (succeeded: Bool, msg: String, return_values: Dictionary<String, AnyObject>) -> () in
                
                if (succeeded) {
                    let userId = return_values["id"]! as! Int
                    let apiToken = return_values["token"]! as! String
                    
                    let prefs:UserDefaults = UserDefaults.standard
                    prefs.setValue(userId, forKey: "USERID")
                    prefs.setValue(apiToken, forKey: "APITOKEN")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { _ in
                        // Code here when user hits 'OK'
                    }

                    alert.title = "Failed!"
                    alert.addAction(action)
                    
                    // Move to the UI thread
                    DispatchQueue.main.async(execute: { () -> Void in
                        // Show the alert
                        self.present(alert, animated: true) {}
                    })
                    
                }

            }
        }
    }
}
