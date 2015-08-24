//
//  FeedCTRL.swift
//  the-galactic-empire
//
//  Created by grobinson on 8/20/15.
//  Copyright (c) 2015 wambl. All rights reserved.
//

import UIKit
import Parse

class FeedCTRL: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var btm: NSLayoutConstraint!
    @IBOutlet weak var messageTXT: UITextView!
    @IBOutlet weak var dock: UIView!
    @IBOutlet weak var sendBTN: UIButton!
    
    var placeholder: String = "Type a message..."
    
    var messages: [PFObject] = []
    
    var tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tap.addTarget(self, action: "dismissKeyboard")
        
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 44.0
        table.rowHeight = UITableViewAutomaticDimension
        table.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
        
        messageTXT.delegate = self
        messageTXT.layer.cornerRadius = 10
        messageTXT.layer.borderColor = UIColor( red: 195/255, green: 195/255, blue: 195/255, alpha: 1.0 ).CGColor
        messageTXT.layer.borderWidth = 1
        messageTXT.text = placeholder
        messageTXT.textColor = UIColor.lightGrayColor()
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        checkText()
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row] as PFObject
        
        let author: PFUser = message["author"] as! PFUser
        
        var cell: MessageCell!
        
        if author.objectId == PFUser.currentUser()?.objectId {
            
            cell = tableView.dequeueReusableCellWithIdentifier("message_me_cell") as! MessageCell
            
        } else {
            
            cell = tableView.dequeueReusableCellWithIdentifier("message_cell") as! MessageCell
            
        }
        
        let a: String = author["displayName"] as! String
        
        cell.authorTXT.text = "\(a):"
        cell.messageTXT.text = message["body"] as? String
        
        return cell
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                
                btm.constant = keyboardHeight
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    
                    self.view.layoutIfNeeded()
                    
                })
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                
                btm.constant = 0.0
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    
                    self.view.layoutIfNeeded()
                    
                })
                
            }
        }
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        self.table.addGestureRecognizer(tap)
        
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1.0)
        }
        
        checkText()
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        self.table.removeGestureRecognizer(tap)
        
        if textView.text.isEmpty || textView.text == placeholder {
            textView.text = placeholder
            textView.textColor = UIColor.lightGrayColor()
        }
        
        checkText()
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        checkText()
        
    }
    
    func dismissKeyboard(){
        
        messageTXT.endEditing(true)
        
    }
    
    func checkText(){
        
        if messageTXT.text == placeholder || messageTXT.text == "" {
            
            sendBTN.enabled = false
            
        } else {
            
            sendBTN.enabled = true
            
        }
        
    }
    
    @IBAction func sendTapped(sender: AnyObject) {
        
        var message = PFObject(className: "Messages")
        
        message["author"] = PFUser.currentUser()
        message["body"] = messageTXT.text
        
        Loading.start()
        
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            
            if (success) {
                
                self.messageTXT.text = self.placeholder
                
                self.dismissKeyboard()
                
                self.messages.append(message)
                
                self.table.reloadData()
                
            } else {
                
                Alert.message("There was an error saving the message")
                
            }
            
            Loading.stop()
            
        }
        
    }
    
    func getMessages(){
        
        var query = PFQuery(className: "Messages")
        query.includeKey("author")
        query.orderByDescending("createdAt")
        query.limit = 20
        
        Loading.start()
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            println("B")
            if error == nil {
                
                if let objects = objects as? [PFObject] {
                    
                    var tmp: [PFObject] = []
                    
                    for object in objects {
                        
                        let o = object as PFObject
                        
                        tmp.append(o)
                        
                    }
                    
                    self.messages = reverse(tmp)
                    
                    self.table.reloadData()
                    
                    self.scrollToBottom()
                    
                } else {
                    
                    println("Parse error!")
                    
                }
                
            } else {
                
                println("Error: \(error!) \(error!.userInfo!)")
                
            }
            
        }
        
        Loading.stop()
        
    }
    
    @IBAction func tester(sender: AnyObject) {
        
        getMessages()
        
    }
    
    func scrollToBottom(){
        
        table.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count - 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        
    }

}