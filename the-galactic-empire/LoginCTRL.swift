//
//  LoginCTRL.swift
//  the-galactic-empire
//
//  Created by grobinson on 8/20/15.
//  Copyright (c) 2015 wambl. All rights reserved.
//

import UIKit
import Parse

class LoginCTRL: UIViewController {

    @IBOutlet weak var gamertagTXT: UITextField!
    @IBOutlet weak var passwordTXT: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    @IBAction func submitClicked(sender: AnyObject) {
        
        login()
        
    }
    
    func login() -> Bool {
        
        if gamertagTXT.text == "" || passwordTXT.text == "" { return false }
        
        Loading.start()
        
        PFUser.logInWithUsernameInBackground(gamertagTXT.text.lowercaseString, password: passwordTXT.text) {
            (user: PFUser?, error: NSError?) -> Void in
            
            Loading.stop()
            
            if user != nil {
                
                var vc = self.storyboard?.instantiateViewControllerWithIdentifier("menu_ctrl") as! MenuCTRL
                
                var nav = UINavigationController(rootViewController: vc)
                
                self.presentViewController(nav, animated: true, completion: nil)
                
            } else {
                
                Alert.message("Invalid login credentials")
                
            }
            
        }
        
        return true
        
    }
    
}